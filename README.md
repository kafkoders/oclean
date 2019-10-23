# Oclean by Kafkoders 
### Thanks to Nasa Space Apps 2019 and Everis Salamanca

# How to deploy the system:

## Deploy the api
1. install mysql and python 3.7
2. create database with oclean_api/db_scrpit/create_db.sql
3. create cron entries to call the oclean_api/cron_scraping/scrape_news.py and oclean_api/cron_scraping/scrape_organizations.py
4. config in the (oclean_api/cron_scraping/)scrape_news.py and scrape_organizations.py scripts the db access information
5. config in oclean_api/api_src/config.py the db and api settings
6. run: python3 oclean_api/setup.py install to install dependencies
7. run: python3 oclean_api/run.py

## web

## iOS app

## ant clustering algorithm