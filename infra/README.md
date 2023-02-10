# infra

Set up and tear down resources in AWS via Terraform.

## Setup

1. `cp auth-example.sh auth.sh` and add the access keys to `auth.sh`
2. `source ./auth.sh` to export the access keys as env vars
3. `terraform init` to install the providers

## Create resources

1. `terraform plan -out plan.out` to output the create resources plan
2. `terraform apply plan.out` to create resources using the plan

## Delete resources

1. `terraform plan -destroy -out destroy.out` to output the delete resources plan
2. `terraform apply destroy.out` to delete resources using the plan

## Resources

- [Terraform CLI cheat sheet](https://acloudguru.com/blog/engineering/the-ultimate-terraform-cheatsheet)
- [Terraform AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
