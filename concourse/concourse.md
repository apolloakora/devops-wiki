
# Concourse Install

You can install and run concourse using **`docker-compose`**. See the [docker-compose file](compose/docker-compose.yml) for the username and password. The one we use here is **`devops4me`** and **`p455word`**

```
brew install wget
git clone https://github.com/devops4me/concourse-pipeline
cd concourse-pipeline/compose
docker-compose up -d
docker ps -a
```

## Setting up the Concourse CLI

The command line tools for the mac can be accessed via this link.

**`http://localhost:4321/api/v1/cli?arch=amd64&platform=darwin`**

Now set it as an executable. If the mac complains about the executable not being trusted go to **`System Preferences`** then **`Security and Privacy`** **`General`** and click **`Allow Anyway`** next to the fly statement.

```
cp ~/Downloads/fly /usr/local/bin/
chmod u+x /usr/local/bin/fly 
fly --version
```

The **`fly --version`** command should now return a sensible value.

## Login to a Fly Target

The name of the target and url are stored in the **`~/.flyrc`** file. The url, port, username and password are stored in the **`docker-compose.yml`** file.

```
fly --target=maclocal login --concourse-url=http://localhost:4321 --username user4me --password p455w0rd
fly -t devops4me login -c http://localhost:4321 -u user4me -p p455w0rd
cd ~/assets
git clone https://github.com/starkandwayne/concourse-tutorial.git
cd concourse-tutorial/tutorials/basic/task-hello-world
fly -t devops4me execute -c task_hello_world.yml
```



## Also See

- **[]()
- **[Concourse YouTube Presentation](https://www.youtube.com/watch?v=m_KpkupKITc)**

