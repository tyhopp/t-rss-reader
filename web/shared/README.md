# t-rss-reader shared resources

Shared resources for [t-rss-reader](https://github.com/tyhopp/t-rss-reader) web clients.

Includes:

- `services`
- `utils`
- `constants`
- `types`

## Usage

This package is pre-installed in each web client.

If you want to change the code, you can uninstall this package from the client and copy this shared code into the client directly.

## Publishing

1. `npm version patch` (or `minor`, `major`, etc.)
2. `npm run build`
3. `npm publish ./dist` (the `./dist` part is important so npm publishes the built files)
