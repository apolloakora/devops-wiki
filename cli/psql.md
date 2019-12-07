
PSQL | Postgres Command Line Interface Client

The docker container will be started 
- with a container name `appdb-container`
- with the Postgres database installed
- with the PSql (Postgres CLI) installed
- a database called app_db

``` bash
sudo docker run                      \
  --name appdb-container             \
      -e POSTGRES_DB=app_db          \
      -e POSTGRES_USER=city_user     \
      -e POSTGRES_PASSWORD=city_pass \
      -p 5432:5432                   \
      -d postgres;
```


## Common Postgres PSQL Commands

```sql
SELECT version();
SELECT current_date;
CREATE TABLE english_city(
   city_id  varchar(8),
   city_name varchar(80),
   city_population int
   );
INSERT INTO english_city VALUES ('X123', 'london', 5000000 );
SELECT * FROM english_city;

UPDATE english_city
SET city_name = 'London Town'
WHERE city_id = 'X123';

SELECT * FROM english_city;
DROP TABLE english_city;
```









