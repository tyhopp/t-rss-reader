# infra

Set up and tear down resources in AWS via Terraform.

## Setup

1. `cp auth-example.sh auth.sh` and add the AWS access keys to `auth.sh`
2. `. ./auth.sh` to export AWS the access keys as env vars in your current shell session
3. `make init` to install the Terraform AWS provider

## Create and delete resources

- `make create` to create the resource plan and apply it
- `make delete` to create the resource deletion plan and apply it

## Useful docs

- [Terraform CLI cheat sheet](https://acloudguru.com/blog/engineering/the-ultimate-terraform-cheatsheet)
- [Terraform AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
