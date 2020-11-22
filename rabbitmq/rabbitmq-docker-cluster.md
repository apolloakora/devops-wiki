
# Creating a RabbitMQ Cluster using Docker

docker run \
    --rm \
    --hostname rabbit1.local \
    --name rabbit1 \
    --publish 4369:4369 \
    --publish 15672:15672 \
    --publish 25672:25672 \
    --publish 5672:5672 \
    --env RABBITMQ_USE_LONGNAME=true \
    --env RABBITMQ_NODENAME=rabbit1 \
    --env RABBITMQ_ERLANG_COOKIE=abcdef0123456789abcdef0123456789 \
    rabbitmq:3-management;


docker run \
    --rm \
    --hostname rabbit2.local \
    --name rabbit2 \
    --publish 16672:15672 \
    --publish 5772:5672 \
    --env RABBITMQ_USE_LONGNAME=true \
    --env RABBITMQ_NODENAME=rabbit2 \
    --env RABBITMQ_ERLANG_COOKIE=abcdef0123456789abcdef0123456789 \
    --link rabbit1:rabbit1.local \
    rabbitmq:3-management;

docker exec -it rabbit2 /bin/bash
rabbitmqctl cluster_status
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl join_cluster rabbit1@rabbit1.local
rabbitmqctl start_app

RABBITMQ_ERLANG_COOKIE env variable support is deprecated and will be REMOVED in a future version. Use the $HOME/.erlang.cookie file or the --erlang-cookie switch instead.
Clustering node rabbit2@rabbit2.local with rabbit1@rabbit1.local

Error:
{:inconsistent_cluster, 'Node \'rabbit1@rabbit1.local\' thinks it\'s clustered with node \'rabbit2@rabbit2.local\', but \'rabbit2@rabbit2.local\' disagrees'}


==============================
On Rabbit 1 - Cluster Status
==============================
Disk Nodes

rabbit1@rabbit1.local
rabbit2@rabbit2.local

Running Nodes

rabbit1@rabbit1.local
==============================

Then run

rabbitmqctl forget_cluster_node rabbit2@rabbit2.local

Removing node rabbit2@rabbit2.local from the cluster

Back on Node 2
rabbitmqctl join_cluster rabbit1@rabbit1.local


docker run \
    --rm \
    --name attack1 \
    --link rabbit1:rabbit1.local \
    pivotalrabbitmq/perf-test:latest \
    --uri amqp://rabbit1



- run a large test (like Sample Load) with n2-standard-8 = 8 vCPU & 32Gb RAM Rabbit Nodes
- either automate or write IAP manual steps within the release script
- make changes to pipelines for deploying to CI, Whitelodge, Greylodge, Blacklodge, PreProd and Prod
- setup environment for testing pipeline activities
- remove all external load balancers (including dev environments) and switch to IAP connecting to NodePort


- decide and implement switch driving the dev/prod configuration
- write script flow for updating rather than installing the RabbitMQ operator
- hook up our own accurately mirrored performance test environment and run looping builds
