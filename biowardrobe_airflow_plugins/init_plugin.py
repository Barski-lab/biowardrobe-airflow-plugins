#! /usr/bin/env python3
import os
import logging
from biowardrobe_airflow_plugins.utils.connect import apply_patch
from biowardrobe_airflow_plugins.utils.func import norm_path

logger = logging.getLogger(__name__)

def main():
    patch_folder = norm_path(os.path.join(os.path.dirname(os.path.abspath(__file__)), "sql_patches", "biowardrobe"))
    patches = ["plugintype_patch.sql"]
    for patch in patches:
        logger.debug(f"Run SQL patch: {os.path.join(patch_folder, patch)}")
        apply_patch(os.path.join(patch_folder, patch))







