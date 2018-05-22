#! /usr/bin/env python3
import os
from biowardrobe_airflow_plugins.utils.connect import apply_patch
from biowardrobe_airflow_plugins.utils.func import norm_path


def main():
    patch_folder = norm_path(os.path.join(os.path.dirname(os.path.abspath(__file__)), "sql_patches", "biowardrobe"))
    patches = ["plugintype_patch.sql", "experimentype2plugintype_view.sql"]
    for patch in patches:
        apply_patch(os.path.join(patch_folder, patch))







