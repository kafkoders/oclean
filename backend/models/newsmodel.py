from sqlmodel import SQLModel

class NewsModel():
	_DB_TABLE = 'newscraper'
	_LOG = logging.getLogger("SQLModel")

	def __init__(host, port, user, password, db_name):
		self.sqlmodel = SQLModel(host, port, user, password, db_name)

	def retrieve_news():
		news_query = f"SELECT url, publicationDate, newspaper, title, description, image from {_DB_TABLE};"
		news_array = self.sqlmodel.retrieve(news_query)
		news = [
			{
				"url": news_array[0],
				"date": news_array[1],
				"newspaper": news_array[2],
				"title": news_array[3],
				"description": news_array[4],
				"image":  news_array[5]
			}
			for new in news_array
		]
		return news