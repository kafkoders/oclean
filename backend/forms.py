from typing import Dict, Any


class Form:

	def validate():
		raise Exception("Not implemented")

	def build_response():
		raise Exception("Not implemented")

	def build_error_response(error):
		return {
			"status": False,
			"error": error
		}

class HeatMapForm(Form):

	def __init__():
		pass

	def validate():
		return True

	def build_response():
		pass



class DonateCCForm(Form):

	def __init__():
		pass

	def validate():
		return True

	def build_response():
		pass



class DonateBlockChainForm(Form):
	
	def __init__():
		pass

	def validate():
		return True

	def build_response():
		pass



class ProblematicsForm(Form):
	
	def __init__():
		pass

	def validate():
		return True

	def build_response():
		pass



class RelatedNewsForm(Form):

	def validate():
		return True

	def build_response(news):
		return {
			"status": True,
			"news": news
		}