import os
import uuid
import logging
from datetime import datetime
from sqlalchemy.exc import SQLAlchemyError
from airflow import settings
from airflow.models import (BaseOperator, DagRun)
from biowardrobe_airflow_plugins.utils.analyze import (get_plugins, get_active_plugins, clean_workspace)


logger = logging.getLogger(__name__)


class BioWardrobePluginTrigger(BaseOperator):

    def __init__(self, *args, **kwargs):
        super(BioWardrobePluginTrigger, self).__init__(task_id=self.__class__.__name__, *args, **kwargs)

    def execute(self, context):
        uid = context['dag_run'].conf['uid']
        active_plugins = get_active_plugins(uid)
        if active_plugins:
            logger.info(f"""Active plugins found for {uid}""")
            for active_plugin in active_plugins:
                logger.info(f"""Skip trigger {active_plugin['dag_id']} because of {active_plugin['run_id']}""")
        else:
            clean_workspace(uid, f"{uid}_default_.*")
            for plugin in get_plugins(uid):
                try:
                    dag_id = os.path.splitext(plugin['workflow'])[0].replace(".", "_dot_")
                    run_id = "__".join(["trig", uid, str(uuid.uuid4())])
                    payload = {'uid': uid, 'run_id': run_id}
                    session = settings.Session()
                    dr = DagRun(dag_id=dag_id,
                                run_id=run_id,
                                conf=payload,
                                external_trigger=True)
                    session.add(dr)
                    session.commit()
                    session.close()
                    logger.info(f"""Trigger {plugin["ptype"]} ({dag_id}) plugin for {uid}:\nrun_id: {run_id}""")
                except SQLAlchemyError as err:
                    logger.error(f"""Failed to trigger {plugin["ptype"]} ({dag_id}) plugin for {uid}\n {err}""")
