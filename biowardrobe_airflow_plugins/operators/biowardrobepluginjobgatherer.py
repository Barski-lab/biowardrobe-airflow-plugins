import os
from cwl_airflow_parser import CWLJobGatherer
from biowardrobe_airflow_plugins.utils.analyze import get_data
from biowardrobe_airflow_plugins.utils.upload import process_results


class BioWardrobePluginJobGatherer(CWLJobGatherer):

    def __init__(self, *args, **kwargs):
        super(BioWardrobePluginJobGatherer, self).__init__(task_id=self.__class__.__name__, *args, **kwargs)

    def execute(self, context):
        job_result, promises = self.cwl_gather(context)
        data = get_data(promises['uid'])
        workflow = os.path.basename(self.dag.cwl_workflow)
        process_results(upload_rules=data['plugins'][workflow]['upload_rules'],
                        uid=promises['uid'],
                        output_folder=self.output_folder)
        return job_result
