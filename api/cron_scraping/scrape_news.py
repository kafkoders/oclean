from GoogleNews import GoogleNews
import flask
import sys

from flask import Flask, request
from flask.json import jsonify
import json
from typing import Any

import pymysql
import logging

################ CONSTANTS ################

# db config
DB_USER = 'root'
DB_PASSWORD = 'fran00'
DB_HOST = 'localhost'
DB_PORT = 3306
DB_NAME = 'nasa'

################ GLOBALS ################

logging.basicConfig(level=logging.INFO)
log = logging.getLogger("test")

connection = pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            db=DB_NAME,
            charset='utf8',
            port=DB_PORT,
            cursorclass=pymysql.cursors.DictCursor)

################ METHODS ################

def scrape():

	link_list = []

	# Instance of class GoogleNews
	googlenews = GoogleNews()
	googlenews.search("oceans"+"+trash")

	for news_item in googlenews.result():
		sql_insert(news_item)

def sql_insert(form):
    try:
        with connection.cursor() as cursor:
            sql = f"INSERT INTO newscraper (url, title, newspaper, publicationDate, description, image) VALUES (\"{form['link']}\", \"{form['title']}\", \"{form['media']}\", \"{form['date']}\", \"{form['desc']}\", \"{form['img']}\");"
            log.info(f"INSERTION CONSULT of SQL:  {sql}")
            cursor.execute(sql)
        connection.commit()
    except Exception as e:
    	log.error(f"INSERT SQL failed, but pass: {str(e)}")
    	pass
    return True

if __name__ == "__main__":
	scrape()