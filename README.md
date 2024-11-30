# t-rss-reader

A personal [RSS](https://en.wikipedia.org/wiki/RSS) reader you can self-host at no cost.

## Project

The project is arranged in these parts:

- Backend [infrastructure](./infra/README.md) built with Terraform and AWS
- Frontend clients that run natively on each platform:

  - [Web](./web/README.md)
  - [iOS, iPadOS, and macOS](./apple/README.md) (WIP)
  - Android (TBD)

- A [Figma design file](./design/README.md) that you can view or duplicate

## Usage

1. Set up the backend [infrastructure](./infra/README.md) so there are endpoints your clients can call.
2. Set up one or more of the clients following their README files.
3. Run clients locally, host, or install them wherever you want.

## Reference

- [Sequence diagrams](./SEQUENCE.md)
