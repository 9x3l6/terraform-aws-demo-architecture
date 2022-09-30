# Terraform AWS Demo Architecture

This repo creates all the required resource to run a secure demo application in the AWS cloud to show a specific use case for a test to get a job.

## How to use

### Key pair
```sh
ssh-keygen -t rsa -f .terraform-aws-demo-architecture-key-pair
```

### Destroy

When you're done trying out the technology you can destroy it and you can build it back again with a single command.

```sh
terraform init && terraform destroy -auto-approve
```

### Apply

```sh
terraform init && terraform plan && terraform apply -auto-approve
```

Running the command above should create the infrastructure and output connection details similar to this

```
Apply complete! Resources: 21 added, 0 changed, 0 destroyed.

Outputs:

app_amazon_linux_id = "ami-0464d49b8794eba32"
app_aws_region = "us-east-1"
app_bastion_host_instance_id = "i-05bce4347aa0e990b"
app_bastion_host_instance_public_dns = "ec2-3-85-38-94.compute-1.amazonaws.com"
app_bastion_host_instance_public_ip = "3.85.38.94"
app_database_address = <sensitive>
app_database_port = 5432
app_database_username = <sensitive>
app_private_server_instance_id = "i-0d02139cb16ce9495"
app_private_server_instance_private_dns = "ip-10-42-2-146.ec2.internal"
app_private_server_instance_private_ip = "10.42.2.146"
app_ssh_key_pair_name = "terraform-aws-demo-architecture"
```

Login to bastion host from anywhere in the world

```sh
ssh -A ec2-user@<app_bastion_host_instance_public_ip>
```

Login to private servers from bastion host

```sh
ssh ec2-user@<app_private_server_instance_private_ip>
```

## Work

I'm looking for a good job with a competitive salary. I talk to many tech recruiters all the time but am still looking for the right team to work with. Yes I say a number for how much I want salary but really I want a number similar to others on the team and one no one else can give me, if possible.


# LICENSE

MIT License

Copyright (c) 2022 ALEKSANDR GORETOY alex@goretoy.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
