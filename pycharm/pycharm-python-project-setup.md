
# PyCharm Python Project Setup

How do we setup a python project that can be run inside

- the Pycharm IDE
- your laptop's command line
- a docker container
- a Kubernetes cluster

## Machine Setup

The most important rule is to never change the system python version - especially on the Mac. When executing a python project in PyCharm or on the command line we need to use **`pyenv`** (to install python environments in our local user space) and **`pip`** to run a virtual environment for our projects.

**[Find out the lastest python release for MacOSx.](https://www.python.org/downloads/mac-osx/)**

- **`brew install pyenv`**   # setup PyEnv to manage multiple python environments on your machine
- **`pyenv versions`**       # look at the versions that you have on your machine
- **`pyenv install 3.9.4`**  # if 3.9.4 is the latest stable python release
- **`pyenv versions`**       # now your newly installed version should show on the list
- **`ls ~/.pyenv/versions`** # this is where pyenv puts the virtual environments

## The PyCharm IDE Setup

Once the machine has been setup with a **`pyenv`** and **`pipenv`** we are ready to configure our python project in PyCharm.

The main steps are

- open the PyCharm IDE
- close any old projects that may be open
- click on open project from version control and enter the git url
- (optional) set the keyboard map to emacs
- on the bottom right corner click to **`Add Interpreter`**
- click on Virtualenv Environments
- **do you remember during machine setup the `.pyenv/versions` folder you installed python into**
- in **Base interpreter** click the 3 dots
- enter **`<HOME>/.pyenv/versions/3.9.4/bin/python`** (if using 3.9.4)
- in Location enter **`<HOME>/PycharmProjects/<PROJECT_NAME>/venv`**

### Create a .gitignore

For best results create a **`.gitignore`** with the following contents.

```
venv/
.idea/
```

### Create a Pipfile

The below pipfile sample will tell pip to bring in behave,pika,psycopg2 and sqlalchemy into the virtual environment.

```
[[source]]
name = "pypi"
url = "https://pypi.org/simple"
verify_ssl = true

[dev-packages]
pytest = "*"
pytest-cov = "*"

[packages]
behave = "*"
paramiko = "*"
pgpy = "*"
pika = "*"
psycopg2-binary = "*"
sqlalchemy = "*"
```


### Using pipenv in PyCharm Terminal

On the bottom of PyCharm click on **`Terminal`**.

- **`pip --version`**  # check that the version comes from the project's **`venv/lib/pythonX.X/site-packages/pip`**
- **`pip install pipenv`**
- **`pipenv --version`**
- **`pipenv shell`**
- **`pipenv install --dev`**

## Run Your Project

Validate all the above work by adding a Hello World python file to the root of the repository.

Contents of **`hello_world.py`**

```
def main():
    print(f'Hello devops wiki world.')

if __name__ == '__main__':
    main()
```

In the IDE terminal (with the pipenv shell) execute this command.

```
pipenv run python hello_world.py
```
