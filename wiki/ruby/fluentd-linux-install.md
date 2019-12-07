
# Fluentd | Unified Logging from Linux


Fluentd is used to collect logs from systems, middleware services and microservice containers and post them to a collection endpoint - like ElasticSearch Logstash and Kibana.


## Fluentd on  Ubuntu 18.04 | Setup and Test

```
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent3.sh | sh  # install fluentd
sudo systemctl start td-agent.service                                                 # restart the agent
sudo systemctl status td-agent.service                                                # discover the status
ls -lh /var/log/td-agent/td-agent.log                                                 # check the logfile exists
tail -f /var/log/td-agent/td-agent.log                                                # tail the fluentd logfile
curl -X POST -d 'json={"json":"Hello World"}' http://localhost:8888/debug.me          # post hello world to the endpoint
```


## Fluentd on CoreOS

```
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent3.sh | sh  # install fluentd
sudo systemctl start td-agent.service                                                 # restart the agent
sudo systemctl status td-agent.service                                                # discover the status
ls -lh /var/log/td-agent/td-agent.log                                                 # check the logfile exists
tail -f /var/log/td-agent/td-agent.log                                                # tail the fluentd logfile
curl -X POST -d 'json={"json":"Hello World"}' http://localhost:8888/debug.me          # post hello world to the endpoint
```


