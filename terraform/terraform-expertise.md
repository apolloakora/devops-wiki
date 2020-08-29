
# The Journey to Terraform Expertise

- how Terraform differs from Ansible
- how Terraform state is mirrored with cloud infrastructure
- how Terraform builds a dependency tree (different from Ansible) and uses it for ordering
- how to visualize a Terraform dependency tree
- how to use VSC with the Terraform plugin
- the main terraform commands - init, plan, apply, destroy, state
- how to pass in variables (command line, environment variables, tfvars file, variables.tf (default)

##########
Code Reuse
##########
- understanding how to reuse Terraform code (equivalent of Ansible Roles)
- pulling in terraform code from Github and other places
- using the terraform registry to pull in code
- releasing your code globally using the Terraform registry



##############
Managing State
##############
- fixing mismatch issues between your tf files, the local state and the cloud
- where terraform state lives
- why some teams use buckets to store Terraform state
- using Jenkins to manage state or Terraform Enterprise
