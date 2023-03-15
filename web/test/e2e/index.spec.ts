/**
 * Playwright does not support shared auth via IndexedDB at present.
 * @link https://github.com/microsoft/playwright/issues/11164
 *
 * Would need to write a hack to inject tokens into IndexedDB and persist them to make it work.
 * Alternatively switch to a proper httpOnly cookie, but that's more work too.
 */
