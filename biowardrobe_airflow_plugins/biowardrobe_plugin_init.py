#! /usr/bin/env python3
import sys
import os
from sqlparse import split
from biowardrobe_airflow_analysis.biowardrobe_init import _settings


def apply_sql_patch(file):
    sql_folder = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "sql_patch"))
    file_abs_path = os.path.join(sql_folder, "biowardrobe_tables", file)
    print(file_abs_path)
    with open(file_abs_path) as ef:
        for _sql in split(ef.read()):
            if not _sql:
                continue
            try:
                _settings.cursor.execute(_sql)
                _settings.conn.commit()
            except Exception as e:
                print("Error: {}".format(e))
                pass


def main():
    try:
        apply_sql_patch ("experimentype2plugintype_view.sql")
        apply_sql_patch ("plugintype_patch.sql")
    except Exception as ex:
        print ("Failed to run SQL patches", ex.str())
        sys.exit(1)







