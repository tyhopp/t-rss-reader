# t-rss-reader

An RSS reader with a serverless backend and multiple native clients.

## Goals

I've always wanted to use an RSS reader regularly, but never been happy with the clients available. The main goal is to fill this gap for me personally.

A secondary goal is to have a small project that gives me a reason to build native clients for several platforms. Some targets I'd like to work on are:

- Web
  - [Svelte](./web/svelte/README.md)
  - Vue
  - React
- iOS
- macOS
- Android
- Windows

It may take years to build it all, and that's fine. I intend to explore slowly. Some platforms I know much better than others, so there will be much learning involved.

## Usage

1. Set up the [infra](./infra/README.md) first, the output of which will be two endpoints (`/login` and `/feeds`) that clients consume
2. Pick a client, run it locally and deploy it to production if you want
