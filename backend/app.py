import logging
from flask import Flask, abort
from flask import request as flask_request
from flask_swagger_ui import get_swaggerui_blueprint
from config import APP_NAME, LOG_NAME, SWAGGER_URL, SWAGGER_FILE, SWAGGER_FILE_URL

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

log = logging.getLogger(LOG_NAME)

################## ERRORS ##################

@app.errorhandler(404)
def not_found(error):
    return "endpoint not found", 404
 
@app.errorhandler(500)
def not_found(error):
    return f"an unknown error occurred: {error}", 500


@app.route(SWAGGER_FILE_URL)
def read_swagger_file():
    with open(SWAGGER_FILE) as f:
        return f.read()


################## SOURCE ##################

@app.route("/v1/heatmap", methods=["GET"])
def heatmap_hdlr():
    log.info(f"GET {flask_request.path}: {flask_request.args}")
    
    log.info(f"GET {flask_request.path}: creating formulary")
    form = HeatMapForm(flask_request)
    if not form.validate():
        log.info(f"GET {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"GET {flask_request.path}: querying model")
    try:
        pass
    except Exception as ex:
        log.info(f"GET {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response()


@app.route("/v1/donate/cc", methods=["POST"])
def donate_cc_hdlr():
    log.info(f"POST {flask_request.path}: {flask_request.args}")
    
    log.info(f"POST {flask_request.path}: creating formulary")
    form = DonateCCForm(flask_request)
    if not form.validate():
        log.info(f"POST {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"POST {flask_request.path}: querying model")
    try:
        pass
    except Exception as ex:
        log.info(f"POST {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response()

@app.route("/v1/donate/blockchain", methods=["POST"])
def donate_blockchain_hdlr():
    log.info(f"POST {flask_request.path}: {flask_request.args}")
    
    log.info(f"POST {flask_request.path}: creating formulary")
    form = DonateBlockChainForm(flask_request)
    if not form.validate():
        log.info(f"POST {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"POST {flask_request.path}: querying model")
    try:
        pass
    except Exception as ex:
        log.info(f"POST {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response()

@app.route("/v1/problematics", methods=["GET"])
def problematics_hdlr():
    log.info(f"GET {flask_request.path}: {flask_request.args}")
    
    log.info(f"GET {flask_request.path}: creating formulary")
    form = ProblematicsForm(flask_request)
    if not form.validate():
        log.info(f"GET {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"GET {flask_request.path}: querying model")
    try:
        pass
    except Exception as ex:
        log.info(f"GET {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response()

@app.route("/v1/news", methods=["GET"])
def news_hdlr():
    log.info(f"GET {flask_request.path}: {flask_request.args}")
    
    log.info(f"GET {flask_request.path}: creating formulary")
    form = RelatedNewsForm(flask_request)
    if not form.validate():
        log.info(f"GET {flask_request.path}: malformed request")
        return form.build_error_response("malformed request"), 403

    log.info(f"GET {flask_request.path}: querying model")
    try:
        pass
    except Exception as ex:
        log.info(f"GET {flask_request.path}: error querying model {ex}")
        return form.build_error_response("internal server error"), 500

    return form.build_response()

