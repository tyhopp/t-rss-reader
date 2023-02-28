# t-rss-reader svelte client

Client built with [SvelteKit](https://kit.svelte.dev/), which relies on [Svelte](https://svelte.dev/) and [Vite](https://vitejs.dev/).

## Prerequisites

1. Set up [infra](../../infra/README.md)
2. Create a `.env` file from the `.env.example` file
3. Add the env vars

## Setup

- `npm install` to install dependencies

## Usage

- `npm run dev` to run in development mode with hot module replacement
- `npm run build` to build production site
- `npm run preview` to view production site

## Disclaimer

An access token with a 1 month expiry is stored in local storage. Reasons:

- Data stored for this app is not particularly sensitive
- Straightforward to revoke access tokens by changing the password
- HTTP-only cookies are not convenient for localhost development

Of course, make your own judgement based on your own requirements. This is acceptable for me for this use case.
