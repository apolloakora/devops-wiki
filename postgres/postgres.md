
# Postgres Database

This command will run a postgres database exposing port 5432 (thanks to the EXPOSE 5432 statement in its dockerfile) and it will create a password for the postgres user "postgres_password_123".

``` bash
docker run --name postgres-db -e POSTGRES_PASSWORD=postgres_password_123 -d postgres
```

The key environment variables that the postgres container will respond to are

- POSTGRES_PASSWORD
- POSTGRES_USER
- POSTGRES_DB



## Install psql on Ubuntu and Emacs

```
sudo apt update --assume-yes
sudo apt install postgresql postgresql-contrib --assume-yes
psql --help
psql --version
# Type alt-x sql-postgres
```
Now to connect using emacs you simply

- type alt-x sql-postgres
- enter the connection details hostname, username, database name and password
- check out your new postgres session

To load a SQL file you use **`\i ~/path/to/file.sql`**


## Using psql

To use psql from the workstation you install postgres first.

``` bash
sudo apt-get install --assume-yes postgresql
```

Psql is the interactive terminal for working with Postgres. The key flags are

    -h the host to connect to
    -U the user to connect with
    -p the port to connect to (default is 5432)

``` bash
psql -h <<hostname>> -U <<username>> <<database_name>>
```

The other option is to use a full string and let psql parse it:

```
psql "dbname=<<DATABASE_NAME>> host=<<DATABASE_HOSTNAME>> user=<<DATABASE_USERNAME>> password=<<DATABASE_PASSWORD>> port=5432 sslmode=require"
```

Once you've connected you can begin querying immediately. In addition to basic queries you can also use certain commands. Running \? will give you a list of all available commands, though a few key ones are called out below.


## The PSQL Command Line

Within the docker container you can access the psql command line and issue commands to explore and change the database.

```
docker run --detach --name vm.postgres --publish 5432:5432 --env POSTGRES_PASSWORD=p455w0rd postgres:latest
psql "dbname=<<DATABASE_NAME>> host=<<DATABASE_HOSTNAME>> user=<<DATABASE_USERNAME>> password=<<DATABASE_PASSWORD>> port=5432 sslmode=require"
brew update && brew install libpq
brew link --force libpq
psql "dbname=postgres host=localhost user=postgres password=p455w0rd port=5432"
# create a table
\list
```


## Creating a Table

CREATE TABLE continent (
id SERIAL PRIMARY KEY,
continent_name VARCHAR NOT NULL,
population NUMERIC(10,2) DEFAULT 0
);

CREATE TABLE country (
id SERIAL PRIMARY KEY,
country_name VARCHAR NOT NULL,
continent_id SERIAL NOT NULL,
created_date DATE DEFAULT CURRENT_DATE,
FOREIGN KEY (continent_id) REFERENCES continent(id),
UNIQUE(country_name)
);

drop table continent;
drop table country;

INSERT INTO continent(id, continent_name, population) VALUES( 1, 'africa', 2000);
INSERT INTO continent(id, continent_name, population) VALUES( 2, 'europe', 2000);
INSERT INTO continent(id, continent_name, population) VALUES( 3, 'north america', 2000);
INSERT INTO continent(id, continent_name, population) VALUES( 4, 'south america', 2000);
INSERT INTO continent(id, continent_name, population) VALUES( 5, 'asia', 2000);
INSERT INTO continent(id, continent_name, population) VALUES( 6, 'australia', 2000);

INSERT INTO country(id, country_name, continent_id) VALUES( 5, 'france', 2);
INSERT INTO country(id, country_name, continent_id, created_date) VALUES( 6, 'netherlands', 2, '1992-08-23' );
INSERT INTO country(id, country_name, continent_id, created_date) VALUES( 1, 'denmark', 2, '1993-08-13' );
INSERT INTO country(id, country_name, continent_id, created_date) VALUES( 3, 'argentina', 4, '1988-02-08' );
INSERT INTO country(id, country_name, continent_id, created_date) VALUES( 4, 'paraguay', 4, '2001-04-28' );
INSERT INTO country(id, country_name, continent_id, created_date) VALUES( 7, 'china', 5, '1995-08-25' );


select country.id as count_id,
       country.country_name as count_name,
       continent.id as continent_id,
       continent.continent_name,
       country.created_date as date_country_created
from country c1, continent c2
where
      c1.continent_id = c2.id;


Ctrl-SPACE Ctrl-e
Ctrl-x r s r
Ctrl-x r i r

Ctrl-x r s q
Ctrl-x r i q


r and e  |  u and i

Now you can explore your database using these commands.
**Note that the semicolon in SQL statements is mandatory**.

```
\pset pager off
\dt *.*
SELECT * FROM pg_catalog.pg_tables;
SELECT * from <<SCHEMA_NAME>>.<<RELATION_NAME>>;
\list
\connect <<DATABASE_NAME>>
\q
```
