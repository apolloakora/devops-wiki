
# Install Sonarqube using Docker

With a **SonarQube Docker** install you can set it up locally first and then deploy it to a Kubernetes or ECS cluster for production deployment. Typically **SonarQube will work alongside Jenkins** and we show you here how to configure a seamless SonarQube Jenkins integration.


### SonarQube | PostgresQL | Aws RDS | Oracle | MySQL

Any serious SonarQube setup will use a production-ready DBMS like MySQL, PostgreSQL, Oracle or SQLServer instead of the onboard H2 database. Here we opt for the dockerized PostgreSQL. For heavily used production environments you would opt for fully featured clustered solutions like Amazon's RDS.


---


## 1. Setup SonarQube with PostgreSQL

First the database access credentials.

Do not use the default sonar/sonar credentials in a production setting. Let's ensure that the

- **username** is suffixed with 7 to 11 random alpha numerics
- **password** contains 18 to 27 alphanumerics
- **database name** should contain less than 64 characters

```
docker run -d \
    --name vm.sonardb \
    --env POSTGRES_USER=rw_Vz9IIdTSAVZi \
    --env POSTGRES_PASSWORD=jcRCb8yleVuKBqLYAcPlwVeQdsd \
    --env POSTGRES_DB=sonarqube_db \
    --network host \
    postgres:11.2;

docker logs vm.sonardb
```

Affirm success via **`docker logs vm.sonardb`** that contains ***`database system is ready to accept connections`***


---


## 2. Run the SonarQube Service


```
docker run              \
    --name vm.sonarqube \
    --detach            \
    --network host      \
    --env sonar.jdbc.username=rw_Vz9IIdTSAVZi                     \
    --env sonar.jdbc.password=jcRCb8yleVuKBqLYAcPlwVeQdsd         \
    --env sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube_db \
    sonarqube:7.7-community;

docker logs vm.sonarqube
```

**[Navigate to the SonarQube UI at port 9000.](http://localhost:9000)**
Affirm that **`docker logs vm.sonarqube`** says ***`app[][o.s.a.SchedulerImpl] SonarQube is up`***.


---


## 3. Create a SonarQube API Access Token

The Jenkins SonarQube plugin needs to talk to SonarQube and it does this best, via an API access token.

To create the token you

- login to the SonarQube UI (the default is admin/admin)
- click on the user icon ( top right  ) then select **`My Account`**
- click on Security, enter a token name then **`Generate Token`**

A token like **`460ac5f22f08d10aed1d9ed569c182dc0d87d22e`** will be produced.

Now during the Jenkins install this token is best secured via the (core) credentials plugin. The SonarQube plugin can then access this via the credential ID you used.


---


## 4. SonarQube User Adminisration

If you are preparing a production SonarQube setup and you plan to reverse engineer the user details - you can set these up locally and then import (with say pgdump) into your production setup.

SonarQube uses the BCrypt algorithm (called a one-way function) to create a hash of the passwords. This means it does not actually store the passwords and it is difficult to derive the passwords from the hash.


---


## 5. Webhook | SonarQube Jenkins Callback Url

SonarQube needs to know the Jenkins URL to callback when it has finished analyzing a given project.

Using the API access token you created (above) is best practise.

```
curl "http://<<sonar.api.access.token>>@<<sonarqube-hostname>>:9000/api/webhooks/create" -X POST -d "name=jenkins&url=http://<<jenkins-hostname>>:8080/sonarqube-webhook/"
```

A successful response from SonarQube looks something like this.

```json
{
  "webhook": {
    "key": "AbcdefgHijkLMOnpqrsTuv123Wxy8z",
    "name": "jenkins",
    "url": "http:\/\/localhost:8080\/sonarqube-webhook\/"
  }
}
```

You can replace the above token with a valid username:password combo like the default **`admin:admin`** credentials.




# Export | Import SonarQube's Database Configuration

In Devops you want to **automate infrastructure provisioning** and **configuration management**.

### Why Avoid Snaphot and Restore

Large projects can afford the overheads of expensive snapshot / dump and restore schemes to provide configuration continuity. However, with each passing day, the **upgrade scenario** becomes a more costly and daunting activity.

### SonarQube Setup | 3 High Level Steps

Smaller projects can avoid this expense by following these setup steps.

1. provision an empty (PostgreSQL) SonrQube database
2. wake up SonarQube and let it **lay down its current schema**
3. inject user configuration data into one table

**This is how to do just that.** It is optional, but when linking with Jenkins it pays to **insert a row** into the **webhooks** and **user tokens** tables. How to do this is also covered.


---



## 1. Useful PostGreSQL Database Queries

Visit the SonarQube Docker Installation blog for the docker commands to setup a PostGreSQL and then a SonarQube container.

Once that's done, use these commands to list Sonar's database tables before, and then after, you startup the SonarQube service.

```
docker exec -it vm.sonardb /bin/bash  # Enter the docker container
psql -U <<username>> -l               # List all available datbases
psql -U <<username>> sonarqube_db  # Access psql command prompt in db
\d                                    # List all tables, views, triggers ...
\dt                                   # List all tables
SELECT * FROM user_tokens;            # Look at the SonarQube tokens
SELECT * FROM users;                  # Look at the SonarQube users
\q                                    # Quit the PSql command prompt
```

### Exporting SonarQube Access Configuration

## 2. Creating SonarQube's Configuration

The steps to secure SonarQube, and subsequently create a clutch of users is

1. login with the default admin admin account
1. change the admin account password and set the display name
1. create an API access token against the administrator's account
1. collate the user's details in a vault
1. create each user via the SonarQube UI perhaps adding them to the administrators group
1. use CUrl to create a SonarQube webhook (Jenkins Callback Url)
1. dump 3 tables - **`users`** | **`user_tokens`** and **`webhooks`**

See the SonarQube Docker setup guide for the **webhook creation** CUrl command.


---


## 3. Dump the SonarQube Database

Use this pg_dump command to dump SonarQube's database into a file containing both DDL and DML (mainly to do with user configuration).

```
pg_dump \
    --host <<db-host-url>>  \
    --port 5432      \
    --format plain   \
    --username <<username>> \
    <<database_name>> >> psql-sonarqube-state.sql;
```

Although we've got everything - really the tables named **`users`**, **`user_tokens`** and **`webhooks`** contain the core of the custom configuration. This along with the option to force user authentication.

Now copy the SQL file from the container onto the host.

```
docker cp <<container_name>>:/psql-sonarqube-dml.sql .
```


---

## 4. Create the SonarQube Database Dockerfile

We need SonarQube's database to be automatically setup when the container is run. Delay the SonarQube service container startup until the database state creation activities are done.

```
FROM postgres:11.2
COPY psql-sonarqube-state.sql /docker-entrypoint-initdb.d/psql-sonarqube-state.sql
```

Build the docker image and push it into a private docker registry.

```
docker build --rm --no-cache --tag <<repository>>/<<image>> .
aws ecr get-login --region eu-west-1 --no-include-email --profile pollen-nonprod
$(aws ecr get-login --region <<region-code>> --no-include-email --profile <<profile-name>>)
docker tag <repository>>/sonardb:latest \
    <<aws-account-no>>.dkr.ecr.<<region-code>>.amazonaws.com/<<repository>>/sonardb:latest
docker push <<aws-account-no>>.dkr.ecr.<<region-code>>.amazonaws.com/<<repository>>/sonardb:latest
```
This gives you a docker login command that can be used for 12 hours. Look at integrating this into the Jenkins so that it uses a simplified docker push syntax in the Jenkinsfile and is non-judgemental about the docker registry of choice.




docker run -d \
  --name vm.sonardb \
  --env POSTGRES_USER=rw_Vz9IIdTSAVZi \
  --env POSTGRES_PASSWORD=jcRCb8yleVuKBqLYAcPlwVeQdsd \
  --env POSTGRES_DB=sonarqube_db \
  --network host \
  966270299484.dkr.ecr.eu-west-1.amazonaws.com/sainsburysnda/sonardb:latest;


docker push 966270299484.dkr.ecr.eu-west-1.amazonaws.com/sainsburysnda/sonardb:latest




lllllllllllllllllllllllllllllllllllll
lllllllllllllllllllllllllllllllllllll
lllllllllllllllllllllllllllllllllllll
lllllllllllllllllllllllllllllllllllll
On the other side, you are now creating the production environment and you want to import the configuration via the dump DML statements. We can do a dry run of this process locally assuming you have your **`psql-sonarqube-dml.sql`** at hand.

We will mount the SQL file using docker's host volumes.

```
docker run -d \
  --name vm.sonardb \
  --env POSTGRES_USER=rw_Vz9IIdTSAVZi \
  --env POSTGRES_PASSWORD=jcRCb8yleVuKBqLYAcPlwVeQdsd \
  --env POSTGRES_DB=sonarqube_db \
  --network host \
  --volume ${PWD}/psql-sonarqube-db.sql:/psql-sonarqube-db.sql \
  postgres:11.2;

############### ==> maybe not --- move this to AFTER the PG_DUMP
############### ==> maybe not --- move this to AFTER the PG_DUMP
############### ==> maybe not --- move this to AFTER the PG_DUMP
############### ==> maybe not --- move this to AFTER the PG_DUMP
############### ==> maybe not --- move this to AFTER the PG_DUMP
############### ==> maybe not --- move this to AFTER the PG_DUMP
############### ==> maybe not --- move this to AFTER the PG_DUMP
############### ==> maybe not --- move this to AFTER the PG_DUMP
############### ==> maybe not --- move this to AFTER the PG_DUMP
############### ==> maybe not --- move this to AFTER the PG_DUMP
docker run              \
    --name vm.sonarqube \
    --detach            \
    --network host      \
    --env sonar.jdbc.username=rw_Vz9IIdTSAVZi                     \
    --env sonar.jdbc.password=jcRCb8yleVuKBqLYAcPlwVeQdsd               \
    --env sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube_db \
    sonarqube:7.7-community;
```

To test the user configuration import we jump into the postgres container and **undump** our data.

```



docker exec -it vm.sonardb /bin/bash  # Enter the docker container

# Read what is in the users table.
######## maybe not
######## maybe not
######## maybe not
######## maybe not
PGPASSWORD=jcRCb8yleVuKBqLYAcPlwVeQdsd psql \
    --echo-queries \
    --host localhost \
    --username rw_Vz9IIdTSAVZi \
    --dbname sonarqube_db \
    --command="SELECT * FROM users";

# Remove the admin / admin user (and then some)
######## maybe not
######## maybe not
######## maybe not
######## maybe not
######## maybe not
######## maybe not
PGPASSWORD=jcRCb8yleVuKBqLYAcPlwVeQdsd psql \
    --echo-queries \
    --host localhost \
    --username rw_Vz9IIdTSAVZi \
    --dbname sonarqube_db \
    --command="DELETE FROM users";

# Import all the user configuration
######## maybe YES yes
######## maybe YES yes
######## maybe YES yes
######## maybe YES yes
PGPASSWORD=jcRCb8yleVuKBqLYAcPlwVeQdsd psql \
    --echo-queries \
    --host localhost \
    --username rw_Vz9IIdTSAVZi \
    --dbname sonarqube_db \
    --file="psql-sonarqube-db.sql";

# Now select from the users, user_tokens and webhooks tables

psql -U rw_Vz9IIdTSAVZi -l         # List all available datbases
psql -U <<username>> sonarqube_db  # Access psql command prompt in db
\d                                    # List all tables, views, triggers ...
\dt                                   # List all tables
SELECT * FROM user_tokens;            # Look at the SonarQube tokens
SELECT * FROM users;                  # Look at the SonarQube users
\q                                    # Quit the PSql command prompt
```




pg_dump \
    --host localhost \
    --port 5432      \
    --format plain   \
    --username rw_Vz9IIdTSAVZi \
    sonarqube_db > psql-sonarqube-db.sql;




pg_dump \
    --host localhost \
    --port 5432      \
    --data-only      \
    --format plain   \
    --username rw_Vz9IIdTSAVZi \
    --table users    \
    sonarqube_db > psql-sonarqube-dml.sql;

pg_dump \
    --host localhost \
    --port 5432      \
    --data-only      \
    --format plain   \
    --username rw_Vz9IIdTSAVZi \
    --table user_tokens    \
    sonarqube_db >> psql-sonarqube-dml.sql;

pg_dump \
    --host localhost \
    --port 5432      \
    --data-only      \
    --format plain   \
    --username rw_Vz9IIdTSAVZi \
    --table webhooks    \
    sonarqube_db >> psql-sonarqube-dml.sql;





safe open cicd.users <<firstname>>
safe put display.name "Full Name"
safe put email.address <<email@address.com>>
safe put jenkins.username <<firstname>>
safe put @jenkins.password <<password>>
safe put sonar.username <<firstname>>
safe put @sonar.password <<password>>
safe commit

---



docker run -d \
  --name vm.sonardb \
  --env POSTGRES_USER=rw_Vz9IIdTSAVZi \
  --env POSTGRES_PASSWORD=jcRCb8yleVuKBqLYAcPlwVeQdsd \
  --env POSTGRES_DB=sonarqube_db \
  --network host \
  postgres:11.2;

docker logs vm.sonardb









