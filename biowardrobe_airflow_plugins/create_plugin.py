#!/usr/bin/env python3
import logging
from datetime import timedelta
from cwl_airflow_parser.cwldag import CWLDAG
from biowardrobe_airflow_plugins.operators.biowardrobepluginjobdispatcher import BioWardrobePluginJobDispatcher
from biowardrobe_airflow_plugins.operators.biowardrobepluginjobgatherer import BioWardrobePluginJobGatherer
from biowardrobe_airflow_plugins.utils.func import get_workflow_by_name


# TODO put all default arguments in config file


def create_plugin(workflow_name):
    dag = CWLDAG(default_args={'owner': 'airflow',
                               'email': ['biowardrobe@biowardrobe.com'],
                               'email_on_failure': False,
                               'email_on_retry': False,
                               'pool': 'biowardrobe_plugins',
                               'retries': 1,
                               'retry_exponential_backoff': True,
                               'retry_delay': timedelta(minutes=60),
                               'max_retry_delay': timedelta(minutes=60*24)},
                 cwl_workflow = get_workflow_by_name(workflow_name))
    dag.create()
    dag.add(BioWardrobePluginJobDispatcher(dag=dag), to='top')
    dag.add(BioWardrobePluginJobGatherer(dag=dag), to='bottom')
    return dag
