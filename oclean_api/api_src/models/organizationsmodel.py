import logging
from models.sqlmodel import SQLModel

class OrganizationsModel:
	_DB_TABLE = 'organizations'
	_DB_TOKEN_TABLE = 'organizations_tokens'
	_LOG = logging.getLogger("OrganizationsModel")

	def __init__(self, host, port, user, password, db_name):
		self.sqlmodel = SQLModel(host, port, user, password, db_name)

	def retrieve_organizations(self):
		orgs_query = f"SELECT id, url, name, description FROM {OrganizationsModel._DB_TABLE};"
		orgs_array = self.sqlmodel.retrieve(orgs_query)
		for org in orgs_array:
			del org['id']
		return orgs_array