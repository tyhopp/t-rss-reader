# t-rss-reader infra

Set up and tear down these resources in AWS via Terraform:

- DynamoDB tables
- Lambda functions
- API Gateways
- IAM roles and policies

## Endpoints

After creating all the resources you end up with these endpoints:

- `/login`
  - `POST` takes your password and returns a [JSON Web Token](https://jwt.io/) to use with subsequent requests
- `/feeds`
  - `GET` gets all feeds
  - `PUT` upserts a feed
  - `DELETE` deletes a feed
- `/entries?url=[FEED_URL]`
  - `GET` gets a feed url's entries. Necessary because most feeds in the wild do not respond with a permissive `Access-Control-Allow-Origin` header, which makes requests to those resources in the browser fail with a CORS error
- `/last-access`
  - `PUT` upserts a timestamp of the last time the application was accessed

See lambda function handler code for the exact signatures.

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

1. Change the Terraform Cloud organization in [`main.tf`](./main.tf) to yours (this value is not possible to declare as a variable)
2. `terraform login`
3. Generate a password to use for authenticating client requests in the application
4. Create a `terraform.tfvars` file from the `terraform-example.tfvars` file
5. Add your generated password and access keys to the `terraform.tfvars` file
6. `make init`

## Create and delete resources

- `make create` to create the resource creation plan and apply it
- `make delete` to create the resource deletion plan and apply it

## Useful docs

- [Terraform CLI cheat sheet](https://acloudguru.com/blog/engineering/the-ultimate-terraform-cheatsheet)
- [Terraform AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Gotchas

- Terraform always updates the lambda functions despite the hash of the output files not changing. It's a [known issue](https://github.com/hashicorp/terraform-provider-aws/issues/17989) that's not a big deal at this scale.
- Terraform sometimes throws a concurrent modification error when creating routes. It looks like this: `Error: creating API Gateway v2 route: ConflictException: Unable to complete operation due to concurrent modification. Please try again later`. Re-run `make create` and the routes not created from the last run will be created. This only happens when all routes are created at once so it doesn't happen enough to make it worth fixing.
- Terraform sometimes doesn't pick up certain changes when diffing, such as DyanmoDB attributes. Run `make destroy` and `make create` to have them applied. This will erase all database items, so beware. Also doesn't happen enough to make it worth fixing.
