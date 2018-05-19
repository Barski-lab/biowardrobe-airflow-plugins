#! /usr/bin/env python3
from biowardrobe_airflow_analysis.biowardrobe_init import apply_sql_patch

def plugin_init():
    print ("Apply sql patches")
    apply_sql_patch ("experimentype2plugintype_view.sql")
    apply_sql_patch ("plugintype_patch.sql")

