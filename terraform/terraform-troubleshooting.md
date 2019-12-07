
# Terraform Troubleshooting

Terraform can quickly become an ordeal for a DevOps engineers with a background in command-centric languages like Python, Java, Go, Ruby and C. Its declarative style with a dependency undercurrent is a taste that takes time to acquire.

Here are some tips to help with troubleshooting.


## Logging the Value of a Variable

How one **finds out a variable's value** after terraform apply fails, is not immediately obvious.

**Python** can log it for us when invoked via Terraform's **external data** feature.

### The Python Script | terraform-debug.py

```python
import sys, logging

logging.basicConfig( filename = 'terraform-debug.log', level = logging.DEBUG, format='%(asctime)s %(message)s', datefmt='%Y%m%d %I:%M:%S %p' )

logging.info( 'Variable 1 is [ %s ]' % ( sys.argv[1] ) )
logging.info( 'Variable 2 is [ %s ]' % ( sys.argv[2] ) )
```

Put the above script in a file called **`terraform-debug.py`** and call it using Terraform's **`external data`** declaration.

### The Terraform Declaration | main.tf

```hcl
data external url
{
    program = [ "python", "${path.module}/terraform-debug.py", "${ var.in_var_1 }", "${ local.our_var_2 }" ]
}
```

After execution a third file appears called **`terraform-debug.log`** containing the values of the two variables passed in.
(Then terraform fails complaining that the return value is not a json string)!

