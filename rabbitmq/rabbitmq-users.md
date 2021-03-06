
# How to Add RabbitMQ Users

## Create a RabbitMQ User with Curl

This curl command will add an administrator user with the given username and password assuming that the default guest:guest account is present.

``` bash
curl -i -u guest:guest -H "content-type:application/json" -XPUT {"password":"<<account_password>>","tags":"administrator"} http://IP_ADRESS:PORT/api/users/<<account_username>>
```

However does it set the 3 dot start permissions?

Also is the port 15672 or something else?


---


## Create a RabbitMQ User with definitions.json

First we need to create the password hash.

### How to Create the RabbitMQ Password Hash

If you need to change the default RabbitMQ password for local development you'll need to edit
- the **`.env`** file **`RABBITMQ_PASSWORD`**
- the **`definitions.json`** file in **`users.password_hash`**

To create the password hash **[copy this python program](https://gist.github.com/anapsix/4c3e8a8685ce5a3f0d7599c9902fd0d5)** and run it feeding it the new password twice. The hash you need is in-between the apostrophes.

**[The hash derivation mechanics are explained here](https://www.rabbitmq.com/passwords.html)**.

### Put User details into definitions.json

For the guest, guest password you would add this hash to the definitions.json

```
  "users": [
    {
      "name": "guest",
      "password_hash": "cTAJdxBZCy5N4cVYPVh0TdRnU1CKTlxiH6mRSee/haEZU33G",
      "hashing_algorithm": "rabbit_password_hashing_sha256",
      "tags": "administrator"
    }
  ],
  "permissions": [
    {
      "user": "guest",
      "vhost": "/",
      "configure": ".*",
      "write": ".*",
      "read": ".*"
    }
  ],
```


---


## Create a RabbitMQ User with rabbitmqctl

If rabbit has been setup say through a docker container you can use docker exec to execute these commands to setup a user.

    rabbitmqctl add_user <<username>> <<password>>
    rabbitmqctl set_user_tags <<username>> administrator
    rabbitmqctl set_permissions -p / <<username>> ".*" ".*" ".*"

The above not only sets up the user but it also sets the important permissions.

## Download rabbitmqadmin and use it to create a user

Once RabbitMQ is installed there is a download link on the screen which **wget** and/or **curl** can be pointed to, to download the admin cli application.

Assuming it is installed locally then this link **http://localhost:15672** should go to a screen which says at the bottom **HTTP API | Command Line** - use this link to download the admin application.

Give it exec permissions and then  use it to create a user. **[Documentation can be found here.](https://www.rabbitmq.com/management-cli.html)**

Helpful rabbitmqadmin commands are as follows.

    rabbitmqadmin -V test list exchanges
    rabbitmqadmin list queues vhost name node messages message_stats.publish_details.rate
    rabbitmqadmin -f long -d 3 list queues

You can connect to admin as another user like the below.

    rabbitmqadmin -H myserver -u simon -p simon list vhosts


## Understanding what RabbitMQ is listening to

rabbitmqctl uses Erlang Distributed Protocol (EDP) to communicate with RabbitMQ. Port 5672 provides AMQP protocol. You can investigate EDP port that your RabbitMQ instance uses:

$ netstat -uptan | grep beam
tcp        0      0 0.0.0.0:55950           0.0.0.0:*               LISTEN      31446/beam.smp  
tcp        0      0 0.0.0.0:15672           0.0.0.0:*               LISTEN      31446/beam.smp  
tcp        0      0 0.0.0.0:55672           0.0.0.0:*               LISTEN      31446/beam.smp  
tcp        0      0 127.0.0.1:55096         127.0.0.1:4369          ESTABLISHED 31446/beam.smp  
tcp6       0      0 :::5672                 :::*                    LISTEN      31446/beam.smp  

It means that RabbitMQ:

    connected to EPMD (Erlang Port Mapper Daemon) on 127.0.0.1:4369 to make nodes able to see each other
    waits for incoming EDP connection on port 55950
    waits for AMQP connection on port 5672 and 55672
    waits for incoming HTTP management connection on port 15672

To make rabbitmqctl able to connect to RabbitMQ you also have to forward port 55950 and allow RabbitMQ instance connect to 127.0.0.1:4369. It is possible that RabbitMQ EDP port is dinamic, so to make it static you can try to use ERL_EPMD_PORT variable of Erlang environment variables or use inet_dist_listen_min and inet_dist_listen_max of Erlang Kernel configuration options and apply it with RabbitMQ environment variable - export RABBITMQ_CONFIG_FILE="/path/to/my_rabbitmq.conf

