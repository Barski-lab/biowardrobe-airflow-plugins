#! /usr/bin/env python3
import os
from json import loads
from collections import OrderedDict


def remove_not_set_inputs(job_object):
    """Remove all input parameters from job which are not set"""
    job_object_filtered ={}
    for key, value in job_object.items():
        if complete_input(value):
            job_object_filtered[key] = value
    return job_object_filtered


def complete_input(item):
    monitor = {"found_none": False}
    recursive_check(item, monitor)
    return not monitor["found_none"]


def recursive_check(item, monitor):
    if item == 'null' or item == 'None' or (isinstance(item, str) and 'None' in item):
        monitor["found_none"] = True
    elif isinstance(item, dict):
        dict((k, v) for k, v in item.items() if recursive_check(v, monitor))
    elif isinstance(item, list):
        list(v for v in item if recursive_check(v, monitor))


def fill_template(template, kwargs):
    job_object = remove_not_set_inputs(loads(template.replace('\n', ' ').format(**kwargs).
        replace("'True'", 'true').replace("'False'", 'false').
        replace('"True"', 'true').replace('"False"', 'false')))
    return OrderedDict(sorted(job_object.items()))


def norm_path(path):
    return os.path.abspath(os.path.normpath(os.path.normcase(path)))