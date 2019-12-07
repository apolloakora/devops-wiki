
# Postgres Docker Use Cases | PSQL | PG_DUMP

The postgres docker container is a handy tool for Devops enginners simply because of the number of use cases it pops up in. A number of these are documented below.

**[Use this terraform module example to clone a database and/or create a fresh database.](https://github.com/devops4me/terraform-aws-postgres-rds/tree/master/example)**

## Postgres Docker as a PG Client


### Export from a Remote Database to a File

Using the **PostgreSQL Docker Container** as a SQL client we will export a remote database into a file of plain-text SQL commands.

```
docker run -d \
  --name vm.pgclient \
  --network host \
  postgres:11.2;
docker exec -it vm.pgclient /bin/bash
```

Now at the postgres client command line you can use **`pg_dump`** to dump an entire database into a file in the docker container. You can also copy the file onto the host using **`docker cp`**.

```
PGPASSWORD=<<DATABASE_PASSWORD>> pg_dump \
    --host <<DATABASE_HOSTNAME>> \
    --port 5432      \
    --format plain   \
    --username <<DATABASE_USERNAME>> \
    <<DATABASE_NAME>> > db-dump-file.sql;
ls -lh
```

The file listing should show the **`db-dump-file.sql`** within the docker container.


### Import from a File to a Remote Database

After the above database export the **`db-dump-file.sql`** should now exist within the docker container. Let's use it to populate a freshly created database.

```
PGPASSWORD="<<DATABASE_PASSWORD>>" psql \
    --echo-queries \
    --host <<DATABASE_HOSTNAME>> \
    --username <<DATABASE_USERNAME>> \
    --dbname <<DATABASE_NAME>> \
    --file=db-dump-file.sql
```

After importing to setup your database schema you can visit the PSQL command line to explore.

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

## Create a PostgreSQL Database for Sonar

You can run a Sonar Docker container using a this postgres database.

```
docker run -d \
  --name vm.sonardb \
  --env POSTGRES_USER=sonar_rw_xyz123abc \
  --env POSTGRES_PASSWORD=xyzP23FSsd8ffa8So2bJw4so \
  --env POSTGRES_DB=sonar_db_hyqlbi \
  --network host \
  postgres:11.2;
```
