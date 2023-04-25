# t-rss-reader

A personal [RSS](https://en.wikipedia.org/wiki/RSS) reader you can self-host at no cost.

## Project

The project is arranged in three parts:

- Backend [infrastructure](./infra/README.md) built with Terraform and AWS
- Frontend clients that run natively on each platform:

  - [Web](./web/README.md)
  - [iOS, iPadOS, and macOS](./apple/README.md) (WIP)
  - CLI (TBD)
  - Windows (TBD)

- A [Figma design file](./design/README.md) that you can view or duplicate

## Usage

1. Set up the backend [infrastructure](./infra/README.md). The output will show the invoke URLs for the endpoints.
2. Set up and run one of the clients. Provide the invoke URLs as environment variables to each client you run.
