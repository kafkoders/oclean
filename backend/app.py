
from flask import Flask, abort


from flask import request as flask_request
from flask_swagger_ui import get_swaggerui_blueprint
from config import APP_NAME, SWAGGER_URL, SWAGGER_FILE, SWAGGER_FILE_URL

app = Flask(APP_NAME)
app.config.from_object('config')
app.register_blueprint(
    get_swaggerui_blueprint(
        SWAGGER_URL,
        SWAGGER_FILE_URL,
        config={
            'app_name': APP_NAME
        }
    )
    , url_prefix=SWAGGER_URL
)

model = None


@app.errorhandler(404)
def not_found(error):
    return "endpoint not found", 404


@app.errorhandler(403)
def not_found(error):
    return "malformed request", 403


@app.errorhandler(500)
def not_found(error):
    return f"an unknown error occurred: {error}", 500


@app.route(SWAGGER_FILE_URL)
def read_swagger_file():
    with open(SWAGGER_FILE) as f:
        return f.read()
