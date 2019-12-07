
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
psql "dbname=<<DATABASE_NAME>> host=<<DATABASE_HOSTNAME>> user=<<DATABASE_USERNAME>> password=<<DATABASE_PASSWORD>> port=5432 sslmode=require"
```

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
