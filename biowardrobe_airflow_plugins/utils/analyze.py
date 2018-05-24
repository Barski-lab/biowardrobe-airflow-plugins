#!/usr/bin/env python3
import logging
import decimal
from json import dumps, loads
from biowardrobe_airflow_plugins.utils.connect import (get_settings, fetchone, fetchall)
from biowardrobe_airflow_plugins.utils.func import (norm_path, fill_template)

logger = logging.getLogger(__name__)


def get_data(uid):
    logger.debug("Collecting data for: {}".format(uid))

    settings = get_settings()

    sql_query = f"""SELECT 
                        l.uid,
                        l.params                           as outputs,
                        l.control_id                       as control_uid,
                        COALESCE(l.trim5,0)                as trim5,
                        COALESCE(l.trim3,0)                as trim3,
                        COALESCE(l.fragmentsizeexp,0)      as exp_fragment_size,
                        COALESCE(l.fragmentsizeforceuse,0) as force_fragment_size,
                        COALESCE(l.rmdup,0)                as remove_duplicates,
                        e.etype                            as exp_type,
                        e.id                               as exp_type_id,
                        g.findex                           as genome_type, 
                        g.gsize                            as genome_size,
                        COALESCE(a.properties,0)           as broad_peak
                    FROM labdata l
                    INNER JOIN (experimenttype e, genome g) ON (e.id=l.experimenttype_id AND g.id=l.genome_id)
                    LEFT JOIN (antibody a) ON (l.antibody_id=a.id)
                    WHERE l.uid='{uid}'"""

    logger.debug(f"SQL query:\n {sql_query}")

    kwargs = fetchone(sql_query)
    kwargs = {key: (value if not isinstance(value, decimal.Decimal) else int(value)) for key, value in kwargs.items()}
    logger.debug(f"SQL query results:\n {kwargs}")

    kwargs.update({
        "outputs": loads(kwargs['outputs']) if kwargs['outputs'] else {},
        "force_fragment_size": (int(kwargs['force_fragment_size']) == 1),
        "remove_duplicates": (int(kwargs['remove_duplicates']) == 1),
        "pair": ('pair' in kwargs['exp_type']),
        "dutp": ('dUTP' in kwargs['exp_type']),
        "broad_peak": (int(kwargs['broad_peak']) == 2),
        "raw_data": norm_path("/".join((settings['wardrobe'], settings['preliminary']))),
        "upload":   norm_path("/".join((settings['wardrobe'], settings['upload']))),
        "indices":  norm_path("/".join((settings['wardrobe'], settings['indices']))),
        "threads": settings['maxthreads'],
        "experimentsdb": settings['experimentsdb']
    })

    plugins = {plugin['workflow']: {'job': fill_template(plugin['template'], kwargs),
                                    'upload_rules': fill_template(plugin['upload_rules'], kwargs)}
               for plugin in fetchall("SELECT * FROM plugintype") if kwargs['exp_type_id'] in loads(plugin['etype_id'])}

    kwargs.update({"plugins": plugins})

    logger.info("Result: \n{}".format(dumps(kwargs, indent=4)))
    return kwargs
