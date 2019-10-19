import json
from typing import Any
from config import DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT

import pymysql

from forms import BlockChainQueryForm, BlockChainRetrieveQuery


class SQLModel:

    def __init__(self):
        self.connection = pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            db=DB_NAME,
            charset='utf8',
            port=DB_PORT,
            cursorclass=pymysql.cursors.DictCursor)

    def insert(self, form: BlockChainQueryForm):
        try:
            with self.connection.cursor() as cursor:
                # Create a new record
                sql = f"INSERT INTO product (id, productData) VALUES ({form.id_},\'{ json.dumps(json.dumps(form.product_information))}\')"
                print(f"insertando pal sql {sql}")
                cursor.execute(sql)
            self.connection.commit()
        except:
            raise
            print("erroraco pal sql")
            return False
        print("to correcto pal sql")
        return True

    def retrieve(self, id_):
        result = None
        try:
            with self.connection.cursor() as cursor:
                sql = f"SELECT * FROM product WHERE id={id_}"
                print(f"haciendo select to guapa {sql}")
                cursor.execute(sql)
                result = cursor.fetchone()
                print(result)
        except:
            raise
            return None
        return result