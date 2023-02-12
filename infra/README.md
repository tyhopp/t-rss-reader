# infra

Set up and tear down resources in AWS via Terraform.

## Prerequisites

Assumes a Unix-like system (e.g. Linux, macOS).

On Windows use [Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm) or run the commands directly without make. Replace zip with [Compress-Archive](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/compress-archive).

- [GNU Make](https://www.gnu.org/software/make/)
- [zip](https://linux.die.net/man/1/zip)
- [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Terraform Cloud account](https://cloud.hashicorp.com/products/terraform)
- [AWS account](https://aws.amazon.com/) with [access keys](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/) created

## Setup

1. `cp auth-example.sh auth.sh` and add the AWS access keys to `auth.sh`
2. `. ./auth.sh` to export AWS the access keys as env vars in your current shell session
3. Change the Terraform Cloud organization and workspace values in [`main.tf`](./src/main.tf) to yours
4. `make init` to initialize Terraform

## Create and delete resources

- `make create` to create the resource plan and apply it
- `make delete` to create the resource deletion plan and apply it

## Useful docs

- [Terraform CLI cheat sheet](https://acloudguru.com/blog/engineering/the-ultimate-terraform-cheatsheet)
- [Terraform AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
