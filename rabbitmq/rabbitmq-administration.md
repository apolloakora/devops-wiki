
# RabbitMQ Administration Commands


## Clustering

```
rabbitmqctl await_online_nodes 2
rabbitmqctl await_startup
rabbitmqctl await_startup <NODE_NAME>
rabbitmqctl join_cluster <SEED_NODE_NAME>
rabbitmqctl forget_cluster_node <NODE_NAME>
```


## Networking

```
rabbitmqctl list_channels
rabbitmqctl list_connections
```


## Queues Exchanges and Bindings

### Read/Query Commands

```
rabbitmqctl list_queues name durable
list_queues name durable arguments policy pid owner_pid messages message_bytes memory state slave_pids
rabbitmqctl list_exchanges
rabbitmqctl list_consumers
rabbitmqctl list_bindings
rabbitmqctl list_hashes
```

### Change/Update Commands

```
rabbitmqctl purge_queue <QUEUE_NAME>
rabbitmqctl sync_queue <QUEUE_NAME>
rabbitmqctl cancel_sync_queue <QUEUE_NAME>
```


## Policies and Parameters

```
rabbitmqctl environment
rabbitmqctl list_policies
rabbitmqctl list_operator_policies
rabbitmqctl list_global_parameters
rabbitmqctl list_parameters
rabbitmqctl list_feature_flags
```

## Users

```
rabbitmqctl list_users
rabbitmqctl list_permissions
rabbitmqctl list_topic_permissions
rabbitmqctl list_user_permissions
rabbitmqctl list_user_topic_permissions
```

