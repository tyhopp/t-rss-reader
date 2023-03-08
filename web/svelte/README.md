# t-rss-reader svelte client

Client built with [SvelteKit](https://kit.svelte.dev/), which relies on [Svelte](https://svelte.dev/) and [Vite](https://vitejs.dev/).

## Prerequisites

- Backend [infrastructure](../../infra/README.md) is created and you have the invoke URLs in hand.

## Setup

1. Create a `.env` file from the `.env.example` file
2. Add the env vars
3. `npm install` to install dependencies

## Usage

- `npm run dev` to run in development mode with hot module replacement
- `npm run build` to build production site
- `npm run preview` to view production site

## Deployment

I use [Firebase Hosting](https://firebase.google.com/docs/hosting), but you can host wherever you want.

To use Firebase Hosting:

1. Install the [Firebase CLI](https://firebase.google.com/docs/cli)
2. Deploy with `npm run deploy`

## Disclaimer

An access token with a 1 month expiry is stored in IndexedDB. Reasons:

- Data stored for this app is not particularly sensitive
- Straightforward to revoke access tokens by changing the password
- HTTP-only cookies are not convenient for localhost development
- Web workers have access to IndexedDB

Of course, make your own judgement based on your own requirements. This is acceptable for me for this use case.
