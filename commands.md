# commands

Commands used during creation of this code, just for reference.

```sh
git init
git checkout -b main

git config --global --edit
git commit --amend --reset-author
git commit -am 'start assessment'

echo -n ".terraform\n.terraform.lock.hcl\nterraform.tfstate*\n.*-key-pair*\n" > .gitignore
ssh-keygen -t rsa -f .terraform-aws-demo-architecture-key-pair

mkdir -p modules/{app-aws-vpc,app-aws-private-instances,app-aws-public-instances,app-aws-database,app-aws-lambda-functions}
touch modules/{app-aws-vpc,app-aws-private-instances,app-aws-public-instances,app-aws-database,app-aws-lambda-functions}/{main.tf,output.tf,vars.tf} main.tf

```

Create the terraform state bucket manually, unless you will use local terraform state.

```sh
aws s3api create-bucket --region us-east-1 --bucket terraform-demo-architecture-state
```

Repeat these commands as developing the code and follow the error trail

```sh
terraform init && terraform plan
terraform init && terraform destroy -auto-approve && terraform plan && terraform apply -auto-approve
terraform init && terraform destroy -auto-approve
```

or this one if you have s3 backend configured

```sh
terraform init -backend-config=backend.hcl && terraform plan
```
