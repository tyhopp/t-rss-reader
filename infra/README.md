# t-rss-reader infra

Set up and tear down these resources in AWS via Terraform:

- DynamoDB tables
- Lambda functions
- API Gateways
- IAM roles and policies

## Endpoints

After creating all the resources you end up with these endpoints:

- `/login`
  - `POST` takes your password and returns a [JSON Web Token](https://jwt.io/)
- `/feeds`
  - `GET` gets all feeds
  - `PUT` upserts a feed
  - `DELETE` deletes a feed
- `/entries?url=[FEED_URL]`
  - `GET` gets a feed's entries
- `/last-access`
  - `PUT` upserts a timestamp of the last time the application was accessed

See lambda function handler code for the exact interfaces.

## Prerequisites

Assumes a Unix-like system (e.g. Linux, macOS) with [make](https://www.gnu.org/software/make/) and [zip](https://linux.die.net/man/1/zip) installed.

- [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Terraform Cloud account](https://cloud.hashicorp.com/products/terraform)
- [AWS account](https://aws.amazon.com/) with [access keys](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/) created

## Setup

1. Change the Terraform Cloud organization in [`main.tf`](./main.tf) to yours (this value is not possible to declare as a variable)
2. `terraform login`
3. Generate a password to use for authenticating client requests in the application
4. Create a `terraform.tfvars` file from the `terraform-example.tfvars` file
5. Add your generated password and AWS access keys to the `terraform.tfvars` file
6. `make init`

## Create and delete resources

- `make create` to create the resource creation plan and apply it
- `make delete` to create the resource deletion plan and apply it

## Cost

All resources have generous limits within the [AWS Free Tier](https://aws.amazon.com/free/).

So, it costs nothing to run this infrastructure unless AWS changes it's free tier limits.

## Gotchas

- Terraform always updates the lambda functions despite the hash of the output files not changing. It's a [known issue](https://github.com/hashicorp/terraform-provider-aws/issues/17989) that's not worth fixing at this scale.
- Terraform sometimes throws a concurrent modification error when creating routes. It looks like this: `Error: creating API Gateway v2 route: ConflictException: Unable to complete operation due to concurrent modification. Please try again later`. Re-run `make create` and the routes not created from the last run will be created. This only happens when all routes are created at once so it doesn't happen enough to make it worth fixing.
- Terraform sometimes doesn't pick up certain changes when diffing, such as DyanmoDB attributes. Run `make destroy` and `make create` to have them applied. This will erase all database items, so beware. Also doesn't happen enough to make it worth fixing.
