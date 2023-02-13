# infra

Set up and tear down these resources in AWS via Terraform:

- DynamoDB table
- Lambda function
- API Gateway
- IAM roles and policies

## Prerequisites

Assumes a Unix-like system (e.g. Linux, macOS).

- [GNU Make](https://www.gnu.org/software/make/)
- [zip](https://linux.die.net/man/1/zip)
- [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Terraform Cloud account](https://cloud.hashicorp.com/products/terraform)
- [AWS account](https://aws.amazon.com/) with [access keys](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/) created

> This project uses Terraform Cloud to share state between multiple machines and make use of locks to avoid conflicts.

> On Windows use [Make for Windows](https://gnuwin32.sourceforge.net/packages/make.htm) or run the commands directly without make. Replace zip with [Compress-Archive](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.archive/compress-archive).

## Setup

1. Change the Terraform Cloud organization in [`main.tf`](./src/main.tf) to yours
2. `terraform login`
3. Create a [Terraform Cloud variable set](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-multiple-variable-sets) with the AWS access keys and give the workspace access to the variable set
4. `make init`

## Create and delete resources

- `make create` to create the resource plan and apply it
- `make delete` to create the resource deletion plan and apply it

## Authorization

Authorization is implemented via the `T_RSS_READER_PASSWORD` environment variable. You will need to create and [add the env var both lambda functions](https://docs.aws.amazon.com/lambda/latest/dg/configuration-envvars.html#configuration-envvars-config).

This application is meant to be used by one person, so there is only one password.

## Useful docs

- [Terraform CLI cheat sheet](https://acloudguru.com/blog/engineering/the-ultimate-terraform-cheatsheet)
- [Terraform AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
