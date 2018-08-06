import os
import re
import argparse
from functools import partial
from collections import OrderedDict
from json import loads
from cwltool.pathmapper import adjustFileObjs, adjustDirObjs, normalizeFilesDirs
from cwltool.process import compute_checksums
from cwltool.stdfsaccess import StdFsAccess
from schema_salad.ref_resolver import file_uri


def remove_not_set_inputs(job_object):
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
    if item == 'None' or (isinstance(item, str) and 'None' in item):
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


def get_files(current_dir, filename_pattern=".*"):
    """Files with the identical basenames are overwritten"""
    files_dict = {}
    for root, dirs, files in os.walk(current_dir):
        files_dict.update(
            {filename: os.path.join(root, filename) for filename in files if re.match(filename_pattern, filename)}
        )
    return files_dict


def get_workflow(workflow_name):
    workflows_folder = norm_path(os.path.join(os.path.dirname(os.path.abspath(os.path.join(__file__, "../"))), "cwls"))
    return get_files(workflows_folder)[workflow_name]


def normalize_args(args, skip_list=[]):
    """Converts all relative path arguments to absolute ones relatively to the current working directory"""
    normalized_args = {}
    for key,value in args.__dict__.items():
        if key not in skip_list:
            normalized_args[key] = value if not value or os.path.isabs(value) else os.path.normpath(os.path.join(os.getcwd(), value))
        else:
            normalized_args[key]=value
    return argparse.Namespace (**normalized_args)


def open_file(filename):
    """Returns list of lines from the text file. \n at the end of the lines are trimmed. Empty lines are excluded"""
    lines = []
    with open(filename, 'r') as infile:
        for line in infile:
            if line.strip():
                lines.append(line.strip())
    return lines


def export_to_file (output_filename, data):
    with open(output_filename, 'w') as output_file:
        output_file.write(data)


def dict_find(dictionary, key):
    for k, v in dictionary.items():
        if k == key:
            yield v
        elif isinstance(v, dict):
            for result in dict_find(v, key):
                yield result
        elif isinstance(v, list):
            for d in v:
                for result in dict_find(d, key):
                    yield result


def validate_locations(dictionary, key="location"):
    for k in list(dictionary.keys()):
        if k == key:
            yield dictionary[k]
        elif isinstance(dictionary[k], dict):
            for result in validate_locations(dictionary[k], key):
                if not os.path.exists(result):
                    del dictionary[k]
        elif isinstance(dictionary[k], list):
            for d in dictionary[k]:
                for result in validate_locations(d, key):
                    if not os.path.exists(result):
                        dictionary[k].remove(d)


def expand_to_file_uri(job_obj):
    if "location" in job_obj:
        job_obj["location"] = file_uri(job_obj["location"])


def add_details_to_outputs(outputs):
    adjustFileObjs(outputs, expand_to_file_uri)
    adjustDirObjs(outputs, expand_to_file_uri)
    normalizeFilesDirs(outputs)
    adjustFileObjs(outputs, partial(compute_checksums, StdFsAccess("")))
    