
# Python Cli | Use SetupTools to Create a Python Command Line App

### Virtual Environments

Virtual environments are for managing Python dependencies and cocooning your Python development. Here we setup a virtual environment called wiki_builder.

``` bash
sudo apt-get install --assume-yes python3-venv
mkdir my.python.space
python3 -m venv wiki_builder
source wiki_builder/bin/activate
deactivate
```

## Creating a Python CLI

Create this in a file called hello.py

``` python
import click

@click.command()
def cli():
    """Example script."""
    click.echo("Hello World!")
```

Then put this in a file in the same directory as hello.py - and call it **setup.py**

``` python
from setuptools import setup

setup(
    name="hello",
    version="0.1",
    py_modules=["hello"],
    install_requires=[
        "Click",
    ],
    entry_points='''
        [console_scripts]
        hello=hello:cli
    ''',
)
```

Now in the same directory as the above two files run the below commands. After the virtual environment command many files are created.

``` bash
python3 -m venv .
ls -lh
source bin/activate
pip install --editable .
hello
```

When you source the activate script the command line becomes prefixed with **(hello_app)** assuming hello_app is the directory your hello.py and setup.py files were in.

**Success!** If all is good the final hello command should garner a response back saying "Hello World!".




