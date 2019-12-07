
# How to Draw Dependency Graphs with Terraform and PyDot

First we install the packages needed for graphing.

```bash
sudo apt-get --assume-yes install graphviz python-pydot python-pydot-ng python-pyparsing libcdt5 libcgraph6 libgvc6 libgvpr2 libpathplan4
```

Now go to the terraform root folder and run this.

```bash
terraform graph | dot -Tpng > es-cloud-infrastructure.png
```

