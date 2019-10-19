from typing import Dict, Any


class Form:

	def validate(self):
		raise Exception("Not implemented")

	def build_response(self):
		raise Exception("Not implemented")

	def build_error_response(self, error):
		return {
			"status": False,
			"error": error
		}

class HeatMapForm(Form):

	def validate(self):
		return True

	def build_response(self):
		pass



class DonateCCForm(Form):

	def validate(self):
		return True

	def build_response(self):
		pass



class DonateBlockChainForm(Form):

	def validate(self):
		return True

	def build_response(self):
		pass



class ProblematicsForm(Form):

	def validate(self):
		return True

	def build_response(self):
		pass



class RelatedNewsForm(Form):

	def validate(self):
		return True

	def build_response(self, news):
		return {
			"status": True,
			"news": news
		}


class OrganizationsPostForm(Form):

	def __init__(self, parameters):
		self.url = parameters['url'] if 'url' in parameters else None
		self.name = parameters['name'] if 'name' in parameters else None
		self.token = parameters['token'] if 'token' in parameters else None
		self.description = parameters['description'] if 'description' in parameters else None

	def validate(self):
		return not (self.url is None or self.name is None or self.token is None or self.description is None)

	def build_response(self):
		return {
			"status": True
		}

class OrganizationsGetForm(Form):

	def validate(self):
		return True

	def build_response(self, organizations):
		return {
			"status": True,
			"organizations": organizations
		}

