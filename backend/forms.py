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


class OrganizationsForm(Form):

	def validate(self):
		return True

	def build_response(self, organizations):
		return {
			"status": True,
			"organizations": organizations
		}

