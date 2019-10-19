import logging
import pymysql


class SQLModel():

	_LOG = logging.getLogger("SQLModel")

    def __init__(self, host, port, user, password, db_name, charset='utf8'):
        self.connection = pymysql.connect(
            host=host,
            port=port,
            db=db_name,
            user=user,
            password=password,
            charset=charset,
            cursorclass=pymysql.cursors.DictCursor)

	def insert(query):
		self._LOG.info(f"insert: {query}")
        try:
            with self.connection.cursor() as cursor:
                cursor.execute(query)
            self.connection.commit()
        except Exception as ex:
			self._LOG.info(f"insert: status error: {query}: {ex}")
            return False
		self._LOG.info(f"insert: status OK: {query}")
        return True

	def retrieve(query):
		self._LOG.info(f"retrieve: {query}")
		result = None
        try:
            with self.connection.cursor() as cursor:
                cursor.execute(query)
                result = cursor.fetchall()
        except Exception as ex:
			self._LOG.info(f"insert: status error: {query}: {ex}")
            return None
		self._LOG.info(f"insert: status OK: {query}")
        return result