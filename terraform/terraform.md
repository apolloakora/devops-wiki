
# Terraform Commands


    $ terraform validate
    $ terraform plan -out=my.plan
    $ terraform show my.plan
    $ terraform apply my.plan

    $ terraform output
    $ terraform output -json
    $ terraform output importer_url

    $ curl -s $(terraform output importer_url)

    $ terraform graph | dot -Tpng > elasticsearch.domain.png

    $ terraform plan -destroy

```bash
terraform destroy                    # destroy with prompt
terraform destroy -auto-approve      # destroy without prompt
```





# Terraform Resources

These are the links to leading terraform resource toolkits.

[RubyMine (or PyCharm or IntelliJ) Terraform Module from HashiCorp](https://www.terraform.io/docs/modules/usage.html)

- [High Quality AWS Terraform Tooling](https://github.com/skyscrapers)

- [All Terraform AWS Resource Examples](https://github.com/terraform-aws-modules)

- [TERRAFORM WITH EVERY AVAILABLE OPTION IN GO CODE](https://github.com/terraform-providers/terraform-provider-aws/tree/master/aws)

- [Terraform Module Documentation](https://www.terraform.io/docs/modules/usage.html)