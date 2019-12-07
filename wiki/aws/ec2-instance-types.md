

# EC2 Instance Types

AWS provides a current list of ec2 instance types (below) but they do not release benchmarks of workloads and different types of middleware services.

[[Current List of EC2 Instance Types]](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html)

We are currently executing benchmark tests from which we will release the results - however some general truths have begun to emerge.

## Choosing The Right Instance Type

The more suitable the (optimized) instance to a type of workload, the cheaper it will be and the better it will perform.

| Instance Workload | Typical Middleware Services | Preferred Optimization? | Instance Options |
|:----------------- |:--------------------------- |:----------------------- |:---------------- |
Compute Middleware | Kubernetes and Docker | Compute and bandwidth optimized espeicially in clustered operation | C Class
Relational DBMS | Postgres, MySQL, Oracle | Storage optimized if write heavy but memory optimized if read heavy | D, H, I Class
NoSQL Databases    | MongoDB, Cassandra | Compute and Storage optimized  | C and D Class
Search Middleware | ElasticSearch, Lucene | Memory Optimized due to JAVA's runtime engine | R, X and Z Class
Queue Middleware | RabbitMQ, Active MQ | Memory and Storage Optimized | R and X Class
Cache (Key/Value) Stores | Redis, ZooKeeper, MemCached, etcd | Memory Optimized as reads from memory are the pillar and overwhelming majority of activities | R and X Class

