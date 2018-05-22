import os
from cwl_airflow_parser import CWLJobDispatcher
from biowardrobe_airflow_plugins.utils.analyze import get_data


class BioWardrobePluginJobDispatcher(CWLJobDispatcher):

    def __init__(self, *args, **kwargs):
        super(BioWardrobePluginJobDispatcher, self).__init__(task_id=self.__class__.__name__, *args, **kwargs)

    def execute(self, context):
        conf = context['dag_run'].conf
        try:
            return self.cwl_dispatch(conf['job'])
        except KeyError:
            workflow = os.path.basename(self.dag.cwl_workflow)
            return self.cwl_dispatch(get_data(conf['uid'])['plugins'][workflow]['job'])

