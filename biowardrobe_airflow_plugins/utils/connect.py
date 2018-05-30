#! /usr/bin/env python3
import MySQLdb                                                 # TODO Do I need to add it into requirements in setup.py
import logging
from contextlib import closing
from airflow.hooks.mysql_hook import MySqlHook
from airflow.utils.db import merge_conn
from airflow import models
from sqlparse import split
from biowardrobe_airflow_plugins.utils.func import open_file


logger = logging.getLogger(__name__)


class Connect:

    def get_conn(self):
        pass

    def execute(self, sql, option=None):
        with closing(self.get_conn()) as connection:
            with closing(connection.cursor()) as cursor:
                cursor.execute(sql)
                connection.commit()
                if option == 1:
                    return cursor.fetchone()
                elif option == 2:
                    return cursor.fetchall()
                else:
                    return None

    def fetchone(self, sql):
        return self.execute(sql,1)

    def fetchall(self, sql):
        return self.execute(sql,2)

    def get_settings(self):
        return {row['key']: row['value'] for row in self.fetchall("SELECT * FROM settings")}

    def apply_patch(self, filename):
        logger.debug(f"Apply SQL patch: {filename}")
        with open(filename) as patch_stream:
            for sql_segment in split(patch_stream.read()):
                if sql_segment:
                    self.execute(sql_segment)


class DirectConnect(Connect):

    def __init__(self, config_file):
        self.config = [line for line in open_file(config_file) if not line.startswith("#")]

    def get_conn(self):
        conn_config = {
            "host": self.config[0],
            "user": self.config[1],
            "passwd": self.config[2],
            "db": self.config[3],
            "port": int(self.config[4]),
            "cursorclass": MySQLdb.cursors.DictCursor
        }
        conn = MySQLdb.connect(**conn_config)
        return conn


class HookConnect(Connect):

    CONNECTION_ID = "biowardrobe"

    def __init__(self, config_file = None):
        if config_file:
            self.config = [line for line in open_file(config_file) if not line.startswith("#")]
            merge_conn(
                models.Connection(
                    conn_id = self.CONNECTION_ID,
                    conn_type = 'mysql',
                    host = self.config[0],
                    login = self.config[1],
                    password = self.config[2],
                    schema = self.config[3],
                    extra = "{\"cursor\":\"dictcursor\"}"))
            self.get_conn()

    def get_conn(self):
        mysql = MySqlHook(mysql_conn_id=self.CONNECTION_ID)
        return mysql.get_conn()
