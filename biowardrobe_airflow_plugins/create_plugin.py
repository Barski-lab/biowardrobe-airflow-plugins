#!/usr/bin/env python3
from datetime import datetime
from airflow.models import DAG
from cwl_airflow_parser.cwldag import CWLDAG
from biowardrobe_airflow_plugins.operators.biowardrobepluginjobdispatcher import BioWardrobePluginJobDispatcher
from biowardrobe_airflow_plugins.operators.biowardrobepluginjobgatherer import BioWardrobePluginJobGatherer
from biowardrobe_airflow_plugins.operators.biowardrobeplugintrigger import BioWardrobePluginTrigger
from biowardrobe_airflow_plugins.utils.func import get_workflow


def create_plugin(workflow_name):
    dag = CWLDAG(default_args={'pool': 'biowardrobe_plugins'},
                 cwl_workflow = get_workflow(workflow_name))
    dag.create()
    dag.add(BioWardrobePluginJobDispatcher(dag=dag), to='top')
    dag.add(BioWardrobePluginJobGatherer(dag=dag), to='bottom')
    return dag


def create_plugin_trigger():
    dag = DAG(
        dag_id='biowardrobe_plugins',
        default_args = {'pool': 'biowardrobe_plugins',
                        'start_date': datetime.now()},
        schedule_interval=None
    )
    trigger = BioWardrobePluginTrigger(dag=dag)
    return dag










