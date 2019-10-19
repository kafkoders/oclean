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
		self.id_ = parameters.get('id')
		self.url = parameters.get('url')
		self.name = parameters.get('name')
		self.token = parameters.get('token')
		self.description = parameters.get('description')

	def validate(self):
		return not (self.id_ is None or self.url is None or self.name is None or self.token is None or self.description is None)

	def build_response(self, organizations):
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

