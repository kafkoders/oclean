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

# Define the application directory
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
