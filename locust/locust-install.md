
# Install Locust on MacOSx

```
brew install libev
python3 -m pip install locust
```

You may need a fresh terminal window.

```
locust --help
```


## Run a Flask Web Counter Application

Go to the Wiki flask directory and run the web counter application which is accessible on port 5000 on the local machine. The app consists of two docker containers

- a python flask webapp container built on the fly
- an Alpine Redis docker container for remembering

## Run Locust

There is a **`locustfile.py`** in this directory which is exactly the name the locust command will look for. On the Mac you may need to allow the app to accept incoming connections.

```
locust     # run the locust command
```

Now go to the website **`http://localhost:8089`** and ask for say **100 users** with a **hatch rate** of say **3 per second** and point locust at the flask app running at **`http://localhost:5000 `**


## Run Locust with Docker

```
docker run --publish 8089:8089 --volume $PWD:/mnt/locust --name vm.locustx locustio/locust -f /mnt/locust/locustfile.py
```


## Run Locust Master and Workers with Docker Compose

```
docker-compose up --scale worker=4
```
