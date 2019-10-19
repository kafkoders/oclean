import logging

from flask import Flask, abort
from flask import request as flask_request
from flask_cors import CORS, cross_origin
from flask_swagger_ui import get_swaggerui_blueprint


from config import DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWD
from config import APP_NAME, LOG_NAME, SWAGGER_URL, SWAGGER_FILE, SWAGGER_FILE_URL

from forms import HeatMapForm, RelatedNewsForm, OrganizationsForm

from models.newsmodel import NewsModel
from models.heatmapmodel import HeatMapModel
from models.organizationsmodel import OrganizationsModel

############# CONFIGURAION ################

app = Flask(APP_NAME)
app.config.from_object('config')
app.config['SECRET_KEY'] = 'the quick brown kafka jumps over the lazy coder'
app.config['CORS_HEADERS'] = 'Content-Type'

cors = CORS(app, resources={r"/v1/news": {"origins": "http://t24h.es:50002"}})

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

log = logging.getLogger(LOG_NAME)

################## MODELS ##################

heatmap_model = HeatMapModel()
news_model = NewsModel(DB_HOST, DB_PORT, DB_USER, DB_PASSWD, DB_NAME)
organization_model = OrganizationsModel(DB_HOST, DB_PORT, DB_USER, DB_PASSWD, DB_NAME)

################## ERRORS ##################

@app.errorhandler(404)
def not_found(error):
    return "endpoint not found", 404


@app.route(SWAGGER_FILE_URL)
def read_swagger_file():
    with open(SWAGGER_FILE) as f:
        return f.read()


################## SOURCE ##################

@app.route("/v1/heatmap", methods=["GET"])
@cross_origin(origin='t24h.es',headers=['Content- Type','application/json'])
def heatmap_endpoint():
    log.info(f"GET {flask_request.path}")
    
    log.info(f"GET {flask_request.path}: creating formulary")
    form = HeatMapForm(flask_request)
    if not form.validate():
        log.info(f"GET {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"GET {flask_request.path}: querying model")
    try:
        heatmap_model.foo()
    except Exception as ex:
        log.info(f"GET {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response()


@app.route("/v1/news", methods=["GET"])
@cross_origin(origin='t24h.es',headers=['Content- Type','application/json'])
def news_endpoint():
    log.info(f"GET {flask_request.path}")
    
    log.info(f"GET {flask_request.path}: creating formulary")
    form = RelatedNewsForm()
    if not form.validate():
        log.info(f"GET {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"GET {flask_request.path}: querying model")
    try:
        news = news_model.retrieve_news()
    except Exception as ex:
        log.info(f"GET {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response(news)

@app.route("/v1/organizations", methods=["GET"])
def organizations_endpoint():
    log.info(f"GET {flask_request.path}")

    log.info(f"GET {flask_request.path}: creating formulary")
    form = OrganizationsForm()
    if not form.validate():
        log.info(f"GET {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"GET {flask_request.path}: querying model")
    try:
        news = organization_model.retrieve_organizations()
    except Exception as ex:
        log.info(f"GET {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response(news)