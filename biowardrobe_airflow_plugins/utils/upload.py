"""Strategy pattern to run BaseUploader.execute depending on types of files to be uploaded"""
import os
import types
import logging
from biowardrobe_airflow_plugins.utils.connect import (fetchone, execute)


logger = logging.getLogger(__name__)

class Uploader:
    def __init__(self, func=None):
        if func is not None:
            self.execute = types.MethodType(func, self)


def process_results(upload_rules, uid, output_folder):
    for func, filename in upload_rules.items():
        Uploader(UPLOAD_FUNCTIONS[func]).execute(uid, os.path.join(output_folder, filename))


def upload_bigbed(self, uid, filename):
    db_name = fetchone(f"SELECT g.db FROM labdata l INNER JOIN genome g ON g.id=l.genome_id WHERE l.uid='{uid}'")['db']
    table_name = db_name + '.`' + str(uid).replace("-", "_") + '_senhncr_f_wtrack`'
    logger.debug(f"Upload bigBed to: {table_name}")
    sql = f"""DROP TABLE IF EXISTS {table_name};
              CREATE TABLE {table_name} (fileName VARCHAR(255) not NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8;
              INSERT INTO {table_name} VALUES ('{filename}');"""
    logger.debug(f"SQL:\n {sql}")
    execute(sql)


UPLOAD_FUNCTIONS = {
    "upload_bigbed": upload_bigbed
}
