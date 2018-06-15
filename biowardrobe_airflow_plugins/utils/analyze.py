#!/usr/bin/env python3
import logging
import decimal
import os
import re
from json import dumps, loads
from airflow.models import DagRun
from airflow.utils.state import State
from biowardrobe_airflow_plugins.utils.connect import HookConnect
from biowardrobe_airflow_plugins.utils.func import (norm_path, fill_template)
from biowardrobe_airflow_plugins.utils.upload import process_results


logger = logging.getLogger(__name__)


def get_data(uid):
    logger.debug(f"Collecting data for: {uid}")
    connect_db = HookConnect()
    settings = connect_db.get_settings()
    sql_query = f"""SELECT
                        l.uid                              as uid,
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

    logger.debug(f"Running SQL query:\n{sql_query}")

    kwargs = connect_db.fetchone(sql_query)
    logger.debug(f"Collecting SQL query results:\n{kwargs}")
    kwargs = {key: (value if not isinstance(value, decimal.Decimal) else int(value)) for key, value in kwargs.items()}

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

    kwargs.update({"plugins": {plugin['workflow']: {'id':           plugin['id'],
                                                    'ptype':        plugin['ptype'],
                                                    'etype_id':     plugin['etype_id'],
                                                    'job':          fill_template(plugin['template'], kwargs),
                                                    'upload_rules': fill_template(plugin['upload_rules'], kwargs)}
                               for plugin in connect_db.fetchall("SELECT * FROM plugintype")
                               if kwargs['exp_type_id'] in loads(plugin['etype_id'])}})

    logger.debug(f"Collected data for: {uid}\n{dumps(kwargs, indent=4)}")
    return kwargs


def get_plugins(uid):
    logger.debug(f"Collecting plugins for: {uid}")
    connect_db = HookConnect()
    exp_type_id = connect_db.fetchone(f"""SELECT e.id FROM experimenttype e
                                          INNER JOIN (labdata l) ON (e.id=l.experimenttype_id)
                                          WHERE l.uid='{uid}'""")["id"]
    plugins = [plugin for plugin in connect_db.fetchall("SELECT id, ptype, workflow, etype_id FROM plugintype")
               if exp_type_id in loads(plugin["etype_id"])]
    return plugins


def get_active_plugins (uid):
    dag_ids = [os.path.splitext(plugin['workflow'])[0].replace(".", "_dot_") for plugin in get_plugins(uid)]
    return [{"dag_id": dag_id,
             "run_id": dagrun.run_id} for dag_id in dag_ids
                                          for dagrun in DagRun.find(dag_id, state=State.RUNNING)
                                              if uid in dagrun.run_id]


def clean_database(uid):
    for workflow, plugin_data in get_data(uid)['plugins'].items():
        process_results(upload_rules=plugin_data['upload_rules'],
                        uid=uid,
                        output_folder=plugin_data['job']['output_folder'],
                        clean=True)


def clean_files(uid, pattern):
    connect_db = HookConnect()
    settings = connect_db.get_settings()
    working_dir = norm_path("/".join((settings['wardrobe'], settings['preliminary'], uid)))
    for file in os.listdir(working_dir):
        if re.match(pattern, file):
            logger.info(f"Removing {os.path.join(working_dir, file)}")
            os.remove(os.path.join(working_dir, file))


def clean_workspace(uid, pattern):
    logger.debug(f"Cleaning workspace for: {uid}")
    clean_database(uid)
    clean_files(uid, pattern)

