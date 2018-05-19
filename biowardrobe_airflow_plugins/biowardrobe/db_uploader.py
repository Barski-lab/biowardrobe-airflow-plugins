"""Strategy pattern to run BaseUploader.execute depending on types of files to be uploaded"""

import os
from biowardrobe_airflow_analysis.biowardrobe.biow_exceptions import BiowUploadException
from biowardrobe_airflow_analysis.biowardrobe.db_uploader import BaseUploader


def upload_results_to_db(upload_rules, uid, output_folder, conn, cursor):
    """Call execute function for all created BaseUploader"""
    for value in upload_rules:
        try:
            BaseUploader(conn, cursor, BIOWARDROBE_UPLOAD_FUNCTIONS[value])\
                .execute(uid, os.path.join(output_folder, BIOWARDROBE_UPLOAD_TEMPLATES[value].format(uid)))
        except Exception as ex:
            raise BiowUploadException(uid, message="Failed to upload {} : {} : {}".format(value, uid, str(ex)))


def upload_bigbed(self, uid, filename):
    self.cursor.execute("SELECT g.db FROM labdata l INNER JOIN genome g ON g.id=l.genome_id WHERE l.uid=%s", (uid,))
    db_tuple = self.cursor.fetchone()
    if not db_tuple:
        raise BiowUploadException(uid, message="DB not found")
    gb_bigbed_table_name = db_tuple['db'] + '.`' + str(uid).replace("-", "_") + '_senh_f_wtrack`'
    self.cursor.execute(f" DROP TABLE IF EXISTS {gb_bigbed_table_name}")
    self.cursor.execute(f""" CREATE TABLE {gb_bigbed_table_name}
                         (fileName VARCHAR(255) not NULL) ENGINE=MyISAM DEFAULT CHARSET=utf8""")
    self.cursor.execute(f" INSERT INTO {gb_bigbed_table_name} VALUES (%s)", (filename,))
    self.conn.commit()


BIOWARDROBE_UPLOAD_FUNCTIONS = {
    "upload_bigbed": upload_bigbed
}

BIOWARDROBE_UPLOAD_TEMPLATES = {
    "upload_bigbed": '{}_super_enhancer.bb'
}
