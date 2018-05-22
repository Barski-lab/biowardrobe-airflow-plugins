#!/usr/bin/env python3
import logging
import decimal
from json import dumps, loads
from biowardrobe_airflow_plugins.utils.connect import (get_settings, fetchone)
from biowardrobe_airflow_plugins.utils.func import (norm_path, fill_template)

logger = logging.getLogger(__name__)


def get_data(uid):
    logger.debug("Collect data for: \n{}".format(uid))

    settings = get_settings()

    sql_query = f"""SELECT 
                        e.etype, e.workflow, e.template, e.upload_rules, 
                        g.db, g.findex, g.annotation, g.annottable, g.genome, g.gsize as genome_size, 
                        l.uid, l.forcerun, l.url, l.params, l.deleted, 
                        COALESCE(l.trim5,0) as clip_5p_end,
                        COALESCE(l.trim3,0) as clip_3p_end,
                        COALESCE(fragmentsizeexp,0) as exp_fragment_size,
                        COALESCE(fragmentsizeforceuse,0) as force_fragment_size,
                        COALESCE(l.rmdup,0) as remove_duplicates,
                        COALESCE(control,0) as control,
                        l.control_id,
                        COALESCE(a.properties,0) as broad_peak,
                        COALESCE(w.email,'') as email,
                        GROUP_CONCAT(p.id SEPARATOR ';') AS plugin_id,
                        GROUP_CONCAT(p.etype SEPARATOR ';') AS plugin_etype,
                        GROUP_CONCAT(p.workflow SEPARATOR ';') AS plugin_workflow,
                        GROUP_CONCAT(p.template SEPARATOR ';') AS plugin_template,
                        GROUP_CONCAT(p.upload_rules SEPARATOR ';') AS plugin_upload_rules
                    FROM labdata l
                    INNER JOIN (experimenttype e, genome g) ON (e.id=l.experimenttype_id AND g.id=l.genome_id)
                    LEFT JOIN (antibody a) ON (l.antibody_id=a.id)
                    LEFT JOIN (worker w) ON (l.worker_id=w.id)
                    LEFT JOIN (experimenttype2plugintype m) ON (m.experimenttype_id=l.experimenttype_id)
                    LEFT JOIN (plugintype p) ON (p.id=m.plugintype_id)
                    WHERE l.uid='{uid}'
                    GROUP BY m.experimenttype_id"""

    logger.debug(f"SQL: {sql_query}")

    kwargs = fetchone(sql_query)

    if not kwargs:
        logger.debug("Failed to collect data for: \n{}".format(uid))
        return None

    kwargs.update({
        "pair": ('pair' in kwargs['etype']),
        "dUTP": ('dUTP' in kwargs['etype']),
        "forcerun": (int(kwargs['forcerun']) == 1),
        "spike": ('spike' in kwargs['genome']),
        "force_fragment_size": (int(kwargs['force_fragment_size']) == 1),
        "broad_peak": (int(kwargs['broad_peak']) == 2),
        "remove_duplicates": (int(kwargs['remove_duplicates']) == 1),
        "params": loads(kwargs['params']) if kwargs['params'] else {},
        "upload_rules": loads(kwargs['upload_rules']) if kwargs['upload_rules'] else [],
        "plugins": {plugin[0]: {'etype': plugin[1],
                                'template': plugin[2],
                                'upload_rules': loads(plugin[3])}
                                for plugin in zip(kwargs['plugin_workflow'].split(';'),
                                                  kwargs['plugin_etype'].split(';'),
                                                  kwargs['plugin_template'].split(';'),
                                                  kwargs['plugin_upload_rules'].split(';'))} if kwargs['plugin_etype'] else {},
        "raw_data": norm_path("/".join((settings['wardrobe'], settings['preliminary']))),
        "upload": norm_path("/".join((settings['wardrobe'], settings['upload']))),
        "indices": norm_path("/".join((settings['wardrobe'], settings['indices']))),
        "threads": settings['maxthreads'],
        "experimentsdb": settings['experimentsdb']
    })

    [kwargs.pop(del_key, None) for del_key in ['plugin_id',
                                               'plugin_etype',
                                               'plugin_workflow',
                                               'plugin_template',
                                               'plugin_upload_rules']]

    kwargs = {key: (value if not isinstance(value, decimal.Decimal) else int(value)) for key, value in kwargs.items()}

    for workflow_name, plugin_data in kwargs['plugins'].items():
        try:
            plugin_data['job'] = fill_template(plugin_data['template'], kwargs)
        except Exception:
            logger.debug(f"Failed to generate job for plugin: {workflow_name}")
            pass

    logger.info("Result: \n{}".format(dumps(kwargs, indent=4)))
    return kwargs
