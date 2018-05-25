#! /usr/bin/env python3
import os
import sys
import logging
import argparse
from typing import Text
from biowardrobe_airflow_plugins.utils.connect import DirectConnect
from biowardrobe_airflow_plugins.utils.func import (norm_path, normalize_args, get_files)

logger = logging.getLogger(__name__)

"""
1. Check if BioWardrobe is installed:
    - check if can read config file
    - check if can access BioWardrobe DB
    - apply plugintype_patch.sql
    - generate params for all experiments as if they were run from CWL
2. Check if Airflow is installed
    - check if can read configuration file
    - check if can locate DAGs folder
    - generate DAGs for all cwl files from cwls folder, put it in DAGs folder
    - add pool for BioWardrobe Plugins
    - check if there is connection to BioWardrobe DB, check if all parameters corresponds to the settings from BioWardrobe config file
      * get the name of that conection if ot exists, if not, create one with default name biowardrobe
3. Check if I can patch Genome Browser DBs
"""


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
    sql_query = """SELECT
                         l.uid    as uid,
                         l.params as outputs,
                         e.etype  as exp_type
                         e.id     as exp_id
                   FROM  labdata l
                   INNER JOIN (experimenttype e) ON (e.id=l.experimenttype_id)
                   WHERE (l.params NOT LIKE '%bambai_pair%') AND
                         (l.params NOT LIKE '%bam_merged%')  AND
                         (l.deleted=0)                       AND
                         (l.libstatus=12)                    AND
                         COALESCE(l.egroup_id,'')<>''        AND
                         COALESCE(l.name4browser,'')<>''"""
    connect_db.fetchall(sql_query)




def setup_biowardrobe(config):
    db_connection_handler = DirectConnect(config)
    apply_patches(db_connection_handler)
    gen_outputs(db_connection_handler)


def main(argsl=None):
    if argsl is None:
        argsl = sys.argv[1:]
    args,_= get_parser().parse_known_args(argsl)
    args = normalize_args(args)
    setup_biowardrobe(args.config)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))


