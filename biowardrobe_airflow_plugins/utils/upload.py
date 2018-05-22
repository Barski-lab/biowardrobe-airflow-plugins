"""Strategy pattern to run BaseUploader.execute depending on types of files to be uploaded"""
import os
import types
from biowardrobe_airflow_plugins.utils.connect import (fetchone, execute)


class Uploader:
    def __init__(self, func=None):
        if func is not None:
            self.execute = types.MethodType(func, self)


def process_results(upload_rules, uid, output_folder):
    for func, template in upload_rules.items():
        Uploader(UPLOAD_FUNCTIONS[func]).execute(uid, os.path.join(output_folder, template.format(uid)))


def upload_bigbed(self, uid, filename):
    db_name = fetchone(f"SELECT g.db FROM labdata l INNER JOIN genome g ON g.id=l.genome_id WHERE l.uid='{uid}'")['db']
    execute(f"""DROP TABLE IF EXISTS {db_name + '.`' + str(uid).replace("-", "_") + '_senhncr_f_wtrack`'};
                CREATE TABLE {table_name} (fileName VARCHAR(255) not NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8;
                INSERT INTO {table_name} VALUES ({filename});""")

UPLOAD_FUNCTIONS = {
    "upload_bigbed": upload_bigbed
}
