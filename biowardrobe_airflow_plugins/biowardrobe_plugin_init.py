#! /usr/bin/env python3
import sys
from biowardrobe_airflow_analysis.biowardrobe_init import apply_sql_patch


def main(argsl=None):
    if argsl is None:
        argsl = sys.argv[1:]
    try:
        print ("Apply sql patches")
        apply_sql_patch ("experimentype2plugintype_view.sql")
        apply_sql_patch ("plugintype_patch.sql")
    except Exception as ex:
        print ("Failed to run SQL patches", ex.str())
        sys.exit(1)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))







