import { getFeedFormat } from './get-feed-format';
import { RssFeedFormat } from '../types';
import { getFeedEntries } from './get-feed-entries';
import type { RssFeedEntries } from '../types';

export function parseFeed(url: string, xml: string): RssFeedEntries {
  const parser = new DOMParser();
  const doc = parser.parseFromString(xml, 'application/xml');

  if (doc.querySelector('parsererror')) {
    throw new Error(`Failed to parse xml of RSS feed '${url}'.`);
  }

  const format = getFeedFormat(doc);

  if (!format) {
    throw new Error(`Unable to determine feed format of RSS feed '${url}'.`);
  }

  if (format !== RssFeedFormat.rss && format !== RssFeedFormat.atom) {
    throw new Error(
      `Feed format is '${format}' for '${url}'. Format must be '${RssFeedFormat.rss}' or '${RssFeedFormat.atom}'.`
    );
  }

  let entries: RssFeedEntries = getFeedEntries(doc, format);

  return entries;
}
