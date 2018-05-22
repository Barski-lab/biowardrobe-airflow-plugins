#! /usr/bin/env python3
from contextlib import closing
from airflow.hooks.mysql_hook import MySqlHook


CONNECTION_ID = "biowardrobe"


def execute(sql, option=None):
    mysql = MySqlHook(mysql_conn_id=CONNECTION_ID)
    with closing(mysql.get_conn()) as connection:
        with closing(connection.cursor()) as cursor:
            cursor.execute(sql)
            return {"1":  cursor.fetchone(),
                    "2":  cursor.fetchall(),
                    None: None}[option]


def fetchone(sql):
    return execute(sql,1).fetchone()


def fetchall(sql):
    return execute(sql,2).fetchall()


def get_settings():
    return {row['key']: row['value'] for row in fetchall("select * from settings")}


def apply_patch(filename):
    with open(filename) as patch_stream:
        execute(patch_stream.read())
