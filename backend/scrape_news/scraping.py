from GoogleNews import GoogleNews
import flask
import sys

from flask import Flask, request
from flask.json import jsonify
import json
from typing import Any
from config import DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT

import pymysql
import logging

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

def news_hdlr():

	link_list = []
	#raw_data = request.json
	#keyword = raw_data['query']

	# Instance of class GoogleNews
	googlenews = GoogleNews()
	googlenews.search("oceans"+"+trash")

	for news_item in googlenews.result():
		sql_insert(news_item)

# create table newscraper (url varchar(300) not null primary key, 
#						   title text, 
#                          newspaper text, 
#                          publicationDate date, description text, image text);

def sql_insert(form):
    try:
        with connection.cursor() as cursor:
            # Create a new record
            sql = f"INSERT INTO newscraper (url, title, newspaper, publicationDate, description, image) VALUES (\"{form['link']}\", \"{form['title']}\", \"{form['media']}\", \"{form['date']}\", \"{form['desc']}\", \"{form['img']}\");"
            log.info(f"INSERTION CONSULT of SQL:  {sql}")
            cursor.execute(sql)
        connection.commit()
    except Exception as e:
    	log.error(f"INSERT SQL failed, but pass: {str(e)}")
    	pass
        #return False

    #log.info(f"sql insertion sucessfully")

    return True

def sql_retrieve(_url):
    result = None

    try:
        with connection.cursor() as cursor:
            sql = f"SELECT * FROM product WHERE url={_url}"

            log.info(f"SELECTION CONSULT: {sql}")

            cursor.execute(sql)
            result = cursor.fetchone()

            log.info(f"Cursor returned {result}")
    except Exception as e:
    	log.error(f"RETRIEVE SQL failed {str(e)}")
    	raise
    	return None

    return result


if __name__ == "__main__":
	news_hdlr()