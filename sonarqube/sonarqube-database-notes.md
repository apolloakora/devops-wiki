
# Export and Import SonarQube's Database Configuration

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


## Useful PostGreSQL Database Queries

Visit the SonarQube Docker Installation blog for the docker commands to setup a PostGreSQL and then a SonarQube container.

Once that's done, use these commands to list Sonar's database tables before, and then after, you startup the SonarQube service.

```
docker exec -it vm.sonardb /bin/bash  # Enter the docker container
psql -U <<username>> -l               # List all available datbases
psql -U <<username>> sonar_db_hyqlbi  # Access psql command prompt in db
\d                                    # List all tables, views, triggers ...
\dt                                   # List all tables
SELECT * FROM user_tokens;            # Look at the SonarQube tokens
SELECT * FROM users;                  # Look at the SonarQube users
\q                                    # Quit the PSql command prompt
```

## Exporting SonarQube Access Configuration

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

## Appendix | Dumping the SonarQube Database

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

## Create the SonarQube Database Dockerfile

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
  --env POSTGRES_USER=sonar_rw_xyz123abc \
  --env POSTGRES_PASSWORD=xyzP23FSsd8ffa8So2bJw4so \
  --env POSTGRES_DB=sonar_db_hyqlbi \
  --network host \
  966270299484.dkr.ecr.eu-west-1.amazonaws.com/projectname/sonardb:latest;


docker push 966270299484.dkr.ecr.eu-west-1.amazonaws.com/projectname/sonardb:latest
