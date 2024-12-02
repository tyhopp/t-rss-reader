import { DOMParser } from 'linkedom';
import { getFeedFormat } from './get-feed-format';
import { getRssEntries } from './get-rss-entries';
import { getAtomEntries } from './get-atom-entries';
import { RssFeedFormat, type RssFeedEntries } from './types';

export function parseFeed(url: string, xml: string): RssFeedEntries {
  const parser = new DOMParser();
  const doc = parser.parseFromString(xml, 'text/xml');

  /**
   * Linkedom does not appear to support parsererror injection on error, so skip that check.
   * @link https://developer.mozilla.org/en-US/docs/Web/API/DOMParser/parseFromString#error_handling
   */

  const format = getFeedFormat(doc);

  if (!format) {
    throw new Error(`Unable to determine feed format of RSS feed '${url}'.`);
  }

  const entries: RssFeedEntries = format === RssFeedFormat.rss
    ? getRssEntries(doc)
    : getAtomEntries(doc);

  return entries;
}
