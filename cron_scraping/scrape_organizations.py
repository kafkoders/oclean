import time
import requests
import pymysql
from lxml.html import fromstring
from investpy.user_agent import get_random


def scrape():
   """
   This function scrapes the first results of Google Search Engine
   """

   head = {
       "User-Agent": get_random(),
       "X-Requested-With": "XMLHttpRequest",
       "Accept": "text/html",
       "Accept-Encoding": "gzip, deflate, br",
       "Connection": "keep-alive",
   }

   query = 'ongs save oceans'
   query = query.replace(' ', '%20')

   url = 'https://www.google.com/search?q=' + query
   
   req = requests.get(url, headers=head)
   
   root = fromstring(req.text)
   path = root.xpath(f".//div[@data-async-context='query:{query}']/div")

   organizations = []
   for val in path:
       if val.xpath(".//h2"):
           for value in val.xpath(".//h2"):
               if value.text_content() == "Resultados web":
                   for content in val.xpath(".//div[@class='srg']/div[@class='g']"):
                       name = content.xpath(".//h3")[0].text_content()
                       website = content.xpath(".//a")[0].get("href")

                       if not website.__contains__("wiki") and not website.__contains__("youtube"):
                           desc = content.xpath(".//span[@class='st']")[0].text_content()

                           organizations.append({
                              "name": name.strip(),
                               "url": website.strip(),
                               "description": desc.strip(),
                           })

   return organizations  


def sql_insert(organizations):

   DB_USER = 'root'
   DB_PASSWORD = 'fran00'
   DB_HOST = 'localhost'
   DB_PORT = 3306
   DB_NAME = 'nasa'

   connection = pymysql.connect(
               host=DB_HOST,
               user=DB_USER,
               password=DB_PASSWORD,
               db=DB_NAME,
               charset='utf8',
               port=DB_PORT,
               cursorclass=pymysql.cursors.DictCursor)
   try:
      with connection.cursor() as cursor:
         sql = f"DELETE FROM organizations;"
         cursor.execute(sql)
      connection.commit()
   except:
      pass    

   for org in organizations:
      try:
         with connection.cursor() as cursor:
            sql = f"INSERT INTO organizations (url, name, description) VALUES (\"{org['url']}\", \"{org['name']}\", \"{org['description']}\");"
            cursor.execute(sql)
         connection.commit()
      except:
         pass

if __name__ == "__main__":
   organizations = scrape()
   sql_insert(organizations)



