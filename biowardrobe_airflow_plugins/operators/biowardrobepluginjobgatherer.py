import logging
import os
from contextlib import closing
from airflow.utils import apply_defaults
from airflow.hooks.mysql_hook import MySqlHook
from ..biowardrobe import get_biowardrobe_data, upload_results_to_db
from biowardrobe_airflow_analysis.biowardrobe import biowardrobe_connection_id
from biowardrobe_airflow_analysis.operators import BioWardrobeJobGatherer


_logger = logging.getLogger(__name__)


class BioWardrobePluginJobGatherer(BioWardrobeJobGatherer):

    ui_color = '#1E88E5'
    ui_fgcolor = '#FFF'

    @apply_defaults
    def __init__(
            self,
            task_id=None,
            reader_task_id=None,
            *args, **kwargs):
        task_id = task_id if task_id else self.__class__.__name__
        super(BioWardrobePluginJobGatherer, self).__init__(task_id=task_id, *args, **kwargs)

        self.outputs = self.dag.get_output_list()
        self.outdir = None
        self.output_folder = None
        self.reader_task_id = None
        self.reader_task_id = reader_task_id if reader_task_id else self.reader_task_id


    def execute(self, context):

        _job_result, promises = self.cwl_gather(context)

        mysql = MySqlHook(mysql_conn_id=biowardrobe_connection_id)
        with closing(mysql.get_conn()) as conn:
            with closing(conn.cursor()) as cursor:
                _data = get_biowardrobe_data(cursor, promises['uid'])
                upload_results_to_db(upload_rules=_data['plugins'][os.path.basename(self.dag.cwl_workflow)]['upload_rules'],
                                      uid=promises['uid'],
                                      output_folder=self.output_folder,
                                      cursor=cursor,
                                      conn=conn)

        return _job_result
