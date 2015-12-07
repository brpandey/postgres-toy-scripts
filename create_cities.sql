CREATE TABLE countries (
	country_code char(2) PRIMARY KEY,
	country_name text UNIQUE
);

INSERT INTO countries (country_code, country_name)
VALUES 	('bz','Brazil'), ('mx','Mexico'), ('nz','New Zealand'),
			('sw','Sweden'), ('de','Germany'), ('us','United States');

DELETE FROM countries
WHERE country_code = 'us';

CREATE TABLE cities (
	name text NOT NULL,
	postal_code varchar(9) CHECK (postal_code <> ''),
	country_code char(2) REFERENCES countries,
	PRIMARY KEY (country_code, postal_code)
);

INSERT INTO cities
VALUES ('Ft. Lauderdale','33301','us');

UPDATE cities
SET postal_code = '84305'
WHERE name = 'Ft. Lauderdale';

SELECT cities.*, country_name
FROM cities INNER JOIN countries
ON cities.country_code = countries.country_code;

CREATE TABLE venues (
	venue_id SERIAL PRIMARY KEY,
	name varchar(255),
	street_address text,
	type char(7) CHECK ( type in ('public','private') ) DEFAULT 'public',
	postal_code varchar(9),
	country_code char(2),
	FOREIGN KEY (country_code, postal_code)
	REFERENCES cities (country_code, postal_code) MATCH FULL
);

