
# Concourse Install

You can install and run concourse using **`docker-compose`**.

```
brew install wget
wget https://concourse-ci.org/docker-compose.yml
docker-compose up -d
docker ps -a
```

## Setting up the Concourse CLI

The command line tools for the mac can be accessed via this link.

**`http://localhost:8080/api/v1/cli?arch=amd64&platform=darwin`**

Now set it as an executable. If the mac complains about the executable not being trusted go to **`System Preferences`** then **`Security and Privacy`** **`General`** and click **`Allow Anyway`** next to the fly statement.

```
cp ~/Downloads/fly /usr/local/bin/
chmod u+x /usr/local/bin/fly 
fly -t tutorial login -c http://localhost:8080 -u test -p test
cd ~/assets
git clone https://github.com/starkandwayne/concourse-tutorial.git
cd concourse-tutorial/tutorials/basic/task-hello-world
fly -t tutorial execute -c task_hello_world.yml

```

