#! /usr/bin/env python3
import sys


def main(argsl=None):
    if sys.argv[1] == "test":
        print ("Dummy message")
        sys.exit(0)
    try:
        from biowardrobe_airflow_analysis.biowardrobe_init import apply_sql_patch
        apply_sql_patch ("experimentype2plugintype_view.sql")
        apply_sql_patch ("plugintype_patch.sql")
    except Exception as ex:
        print ("Failed to run SQL patches", ex.str())
        sys.exit(1)







