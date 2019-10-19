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

	def insert_organization(self, id_, url, name, description):
		orgs_query = f"INSERT INTO {OrganizationsModel._DB_TABLE} (id, url, name, description) VALUES({id_}, \'{url}\', \'{name}\', \'{desription}\')"
		result = self.sqlmodel.insert(orgs_query)
		return result

	def validate_token(self, token):
		token_query = f"SELECT token FROM {OrganizationsModel._DB_TOKEN_TABLE};"
		token_array = self.sqlmodel.retrieve(token_query)
		token_list = [token_element['token'] for token_element in token_array]
		return (token in token_array)
