#!/usr/bin/env python3
import logging
import decimal
from json import dumps, loads
from biowardrobe_airflow_analysis.biowardrobe.utils import biowardrobe_settings
from .utils import norm_path, fill_template
from biowardrobe_airflow_analysis.biowardrobe.constants import (STAR_INDICES,
                                                                BOWTIE_INDICES,
                                                                CHR_LENGTH_GENERIC_TSV,
                                                                ANNOTATIONS,
                                                                ANNOTATION_GENERIC_TSV)


_logger = logging.getLogger(__name__)


def get_biowardrobe_data(cursor, biowardrobe_uid):
    """Generate and export job file to a specific folder"""
    _logger.debug("Collect data for: \n{}".format(biowardrobe_uid))
    _settings = biowardrobe_settings(cursor)

    _sql = f"""select 
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

        from labdata l

        INNER JOIN (experimenttype e, genome g) ON (e.id=l.experimenttype_id AND g.id=l.genome_id)
        LEFT JOIN (antibody a) ON (l.antibody_id=a.id)
        LEFT JOIN (worker w) ON (l.worker_id=w.id)

        LEFT JOIN (experimenttype2plugintype m) ON (m.experimenttype_id=l.experimenttype_id)
        LEFT JOIN (plugintype p) ON (p.id=m.plugintype_id)

        where l.uid='{biowardrobe_uid}'
        GROUP BY m.experimenttype_id """

    _logger.debug(f"SQL: {_sql}")

    cursor.execute(_sql)
    kwargs = cursor.fetchone()

    if not kwargs:
        _logger.debug("Failed to collect data for: \n{}".format(biowardrobe_uid))
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
        "raw_data": norm_path("/".join((_settings['wardrobe'], _settings['preliminary']))),
        "upload": norm_path("/".join((_settings['wardrobe'], _settings['upload']))),
        "indices": norm_path("/".join((_settings['wardrobe'], _settings['indices']))),
        "threads": _settings['maxthreads'],
        "experimentsdb": _settings['experimentsdb']
    })

    [kwargs.pop(del_key, None) for del_key in ['plugin_id',
                                               'plugin_etype',
                                               'plugin_workflow',
                                               'plugin_template',
                                               'plugin_upload_rules']]

    kwargs.update({
        # TODO: move extension into database
        "fastq_file_upstream": norm_path("/".join((kwargs["raw_data"], kwargs["uid"], kwargs["uid"] + '.fastq.bz2'))),
        "fastq_file_downstream": norm_path("/".join((kwargs["raw_data"], kwargs["uid"], kwargs["uid"] + '_2.fastq.bz2'))),
        "star_indices_folder": norm_path("/".join((kwargs["indices"], STAR_INDICES, kwargs["findex"]))),
        "bowtie_indices_folder": norm_path("/".join((kwargs["indices"], BOWTIE_INDICES, kwargs["findex"]))),
        "bowtie_indices_folder_ribo": norm_path("/".join((kwargs["indices"], BOWTIE_INDICES, kwargs["findex"] + "_ribo"))),
        "chrom_length": norm_path("/".join((kwargs["indices"], BOWTIE_INDICES, kwargs["findex"], CHR_LENGTH_GENERIC_TSV))),
        "annotation_input_file": norm_path("/".join((kwargs["indices"], ANNOTATIONS, kwargs["findex"],ANNOTATION_GENERIC_TSV))),
        "exclude_chr": "control" if kwargs["spike"] else "",
        "output_folder": norm_path("/".join((kwargs["raw_data"], kwargs["uid"]))),
        "control_file": norm_path("/".join((kwargs["raw_data"], kwargs["control_id"], kwargs["control_id"] + '.bam')))
        if kwargs['control_id'] else None
    })

    kwargs = {key: (value if not isinstance(value, decimal.Decimal) else int(value)) for key, value in kwargs.items()}
    kwargs['job'] = fill_template(kwargs['template'], kwargs)

    for workflow_name, plugin_data in kwargs['plugins'].items():
        try:
            plugin_data['job'] = fill_template(plugin_data['template'], kwargs)
        except Exception:
            _logger.debug(f"Failed to generate job for plugin: {workflow_name}")
            pass

    _logger.info("Result: \n{}".format(dumps(kwargs, indent=4)))
    return kwargs
