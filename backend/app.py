import logging

from flask import Flask, abort
from flask import request as flask_request
from flask_cors import CORS, cross_origin
from flask_swagger_ui import get_swaggerui_blueprint


from config import DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWD
from config import APP_NAME, LOG_NAME, SWAGGER_URL, SWAGGER_FILE, SWAGGER_FILE_URL

from forms import HeatMapForm, DonateCCForm, DonateBlockChainForm, \
    ProblematicsForm, RelatedNewsForm, OrganizationsForm

from models.newsmodel import NewsModel
from models.heatmapmodel import HeatMapModel
from models.donationmodel import DonationModel
from models.blockchainmodel import BlockChainModel
from models.problematicsmodel import ProblematicsModel 
from models.organizationsmodel import OrganizationsModel

############# CONFIGURAION ################

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

log = logging.getLogger(LOG_NAME)

################## MODELS ##################

blockchain_model = BlockChainModel()
heatmap_model = HeatMapModel()
donation_model = DonationModel()
problematics_model = ProblematicsModel()
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


@app.route("/v1/donate/cc", methods=["POST"])
def donate_cc_endpoint():
    log.info(f"POST {flask_request.path}")
    
    log.info(f"POST {flask_request.path}: creating formulary")
    form = DonateCCForm(flask_request)
    if not form.validate():
        log.info(f"POST {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"POST {flask_request.path}: querying model")
    try:
        donation_model.foo()
    except Exception as ex:
        log.info(f"POST {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response()

@app.route("/v1/donate/blockchain", methods=["POST"])
def donate_blockchain_endpoint():
    log.info(f"POST {flask_request.path}")
    
    log.info(f"POST {flask_request.path}: creating formulary")
    form = DonateBlockChainForm(flask_request)
    if not form.validate():
        log.info(f"POST {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"POST {flask_request.path}: querying model")
    try:
        donation_model.foo()
    except Exception as ex:
        log.info(f"POST {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response()

@app.route("/v1/problematics", methods=["GET"])
def problematics_endpoint():
    log.info(f"GET {flask_request.path}")
    
    log.info(f"GET {flask_request.path}: creating formulary")
    form = ProblematicsForm(flask_request)
    if not form.validate():
        log.info(f"GET {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"GET {flask_request.path}: querying model")
    try:
        problematics_model.foo()
    except Exception as ex:
        log.info(f"GET {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response()

@app.route("/v1/news", methods=["GET"])
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