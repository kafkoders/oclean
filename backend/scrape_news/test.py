from GoogleNews import GoogleNews
import flask
from flask import Flask, request
from flask.json import jsonify

api = Flask("miappi")

@api.route("/v1/news", methods=['GET'])
def news_hdlr():

	link_list = []
	raw_data = request.json
	keyword = raw_data['query']

	# Instance of class GoogleNews
	googlenews = GoogleNews()
	googlenews.search(keyword+"+trash")

	return jsonify({'news': googlenews.result()})

if __name__ == "__main__":
	api.run(host="0.0.0.0", port=5000)