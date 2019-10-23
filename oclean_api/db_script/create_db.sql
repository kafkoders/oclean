CREATE DATABASE NASA;

USE NASA;

CREATE TABLE newscraper(
	url VARCHAR(300) NOT NULL PRIMARY KEY,
	title TEXT, 
	newspaper TEXT, 
	publicationDate VARCHAR(100),
	description TEXT
);

CREATE TABLE organizations(
	id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	url TEXT,
	name TEXT, 
	description TEXT
)