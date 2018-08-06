#! /usr/bin/env python3
import os
import sys
import logging
import argparse
from typing import Text
from json import dumps, loads

from biowardrobe_airflow_plugins.utils.connect import (DirectConnect, HookConnect)
from biowardrobe_airflow_plugins.utils.func import (norm_path,
                                                    normalize_args,
                                                    get_files,
                                                    fill_template,
                                                    validate_locations,
                                                    add_details_to_outputs)
from biowardrobe_airflow_plugins.templates.outputs import OUTPUT_TEMPLATES

from airflow.settings import DAGS_FOLDER
from airflow.bin.cli import api_client


logger = logging.getLogger(__name__)


def get_parser():
    parser = argparse.ArgumentParser(description='BioWardrobe Airflow Plugins', add_help=True)
    parser.add_argument("-c", "--config", type=Text, help="Path to the BioWardrobe config file", default="/etc/wardrobe/wardrobe")
    return parser


def apply_patches(connect_db):
    current_dir = os.path.dirname(os.path.abspath(__file__))

    bw_patches = get_files(norm_path(os.path.join(current_dir, "sql_patches", "biowardrobe")), ".*sql$")
    gb_patches = get_files(norm_path(os.path.join(current_dir, "sql_patches", "genome_browser")), ".*sql$")

    if not connect_db.fetchone("SHOW TABLES LIKE 'plugintype'"):
        connect_db.apply_patch(bw_patches["plugintype_create.sql"])

    connect_db.apply_patch(bw_patches["plugintype_patch.sql"])

    for filename in gb_patches.values():
        try:
            connect_db.apply_patch(filename)
        except Exception:
            pass


def gen_outputs(connect_db):
    settings = connect_db.get_settings()
    raw_data = norm_path("/".join((settings['wardrobe'], settings['preliminary'])))
    sql_query = """SELECT
                         l.uid                    as uid,
                         l.params                 as outputs,
                         e.etype                  as exp_type,
                         e.id                     as exp_id,
                         COALESCE(a.properties,0) as peak_type
                   FROM  labdata l
                   INNER JOIN (experimenttype e) ON (e.id=l.experimenttype_id)
                   LEFT JOIN (antibody a) ON (l.antibody_id=a.id)
                   WHERE (l.params NOT LIKE '%file:%') AND
                         (l.deleted=0)                 AND
                         (l.libstatus=12)              AND
                         COALESCE(l.egroup_id,'')<>''  AND
                         COALESCE(l.name4browser,'')<>''"""

    for kwargs in connect_db.fetchall(sql_query):
        try:
            kwargs.update({"raw_data":   raw_data,
                           "peak_type": "broad" if int(kwargs['peak_type']) == 2 else "narrow",
                           "outputs":    loads(kwargs['outputs']) if kwargs['outputs'] and kwargs['outputs'] != "null" else {}})
            kwargs["outputs"]["promoter"] = kwargs["outputs"]["promoter"] if "promoter" in kwargs["outputs"] else 1000
            for template in OUTPUT_TEMPLATES[kwargs['exp_id']][kwargs['peak_type']]:
                kwargs["outputs"].update(fill_template(template, kwargs))
            list(validate_locations(kwargs))
            add_details_to_outputs(kwargs["outputs"])
            connect_db.execute(f"""UPDATE labdata SET params='{dumps(kwargs["outputs"])}' WHERE uid='{kwargs["uid"]}'""")
            logger.info(f"""Update params for {kwargs['uid']}\n {dumps(kwargs["outputs"], indent=4)}""")
        except Exception:
            logger.debug(f"Failed to updated params for {kwargs['uid']}")


def export_dag(template, filename):
    output_filename = os.path.abspath(os.path.join(DAGS_FOLDER, os.path.splitext(filename)[0]+".py"))
    with open(output_filename, 'w') as output_stream:
        output_stream.write(template.format(filename))


def create_dags():
    current_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "cwls")
    template = u"""#!/usr/bin/env python3\nfrom airflow import DAG\nfrom biowardrobe_airflow_plugins import biowardrobe_plugin\ndag = biowardrobe_plugin("{}")"""
    for filename, path in get_files(current_dir).items():
        export_dag(template, filename)
    biowardrobe_plugin_trigger = u"#!/usr/bin/env python3\nfrom airflow import DAG\nfrom biowardrobe_airflow_plugins import biowardrobe_plugin_trigger\ndag = biowardrobe_plugin_trigger()"
    export_dag(biowardrobe_plugin_trigger, "biowardrobe_plugins")

def create_pools():
    try:
        pools = [api_client.get_pool(name="biowardrobe_plugins")]
    except Exception:
        api_client.create_pool(name="biowardrobe_plugins", slots=10, description="pool to run BioWardrobe plugins")


def create_connection(config):
    HookConnect(config)


def setup_airflow(config):
    create_connection(config)
    create_pools()
    create_dags()


def setup_biowardrobe(config):
    db_connection_handler = DirectConnect(config)
    apply_patches(db_connection_handler)
    gen_outputs(db_connection_handler)


def main(argsl=None):
    if argsl is None:
        argsl = sys.argv[1:]
    args,_ = get_parser().parse_known_args(argsl)
    args = normalize_args(args)

    setup_biowardrobe(args.config)
    setup_airflow(args.config)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))


