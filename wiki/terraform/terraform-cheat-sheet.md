
# Terraform Cheat Sheet

## terraform_remote_state | pass variables with '''local backend'''

**terraform_remote_state** is a type of **data source** enabling you to access data from a previous run. That data may be in another folder on your build server (eg Jenkins) or it could be in an S3 bucket that you've mounted using NFS.

    ### ############################### ###
    ### [[data]] terraform_remote_state ###
    ### ############################### ###

    data terraform_remote_state info
    {
        backend = "local"

        config
        {
            path = "${path.module}/../../${var.abcdefg_dir}/terraform.tfstate"
        }
    }

The "local" backend denotes that the path is on a locally accessible filesystem.

### Using remote state information

If the remote terraform run exported **root_out_vpc_id** and **root_out_subnet_ids** you can access the data like this.

    module abcd_module
    {
        source        = "abcd"
        in_vpc_id     = "${ data.terraform_remote_state.info.root_out_vpc_id }"
        in_subnet_ids = [ "${ data.terraform_remote_state.info.root_out_subnet_ids }" ]
    }

#### Architecture Example | A Blue - Green Deployment

When rebuilding "green" infrastructure you may need information from the "blue" infrastructure.
You could use terraform_remote_state to access that data from a locally accessible filesystem (like an S3 bucket mounted with NFS).
