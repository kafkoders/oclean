import os

# Statement for enabling the development environment
DEBUG = True

# Host and port for server to bind to
PORT = 8000
HOST = '0.0.0.0'

# app name
APP_NAME = 'nasa_space_apps'

# swagger configuration
SWAGGER_URL = '/v1/doc'
SWAGGER_FILE = 'resources/swagger.json'
SWAGGER_FILE_URL = '/v1/doc/swagger.json'

# define the application directory
BASE_DIR = os.path.abspath(os.path.dirname(__file__))

# log configuration
LOG_NAME = APP_NAME

# db config
DB_USER = 'root'
DB_PASSWD = 'fran00'
DB_HOST = 'localhost'
DB_PORT = 3306
DB_NAME = 'nasa'