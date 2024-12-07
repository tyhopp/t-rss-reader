import type { RssFeedEntries } from './types';
import type { XMLDocument } from 'linkedom/types/xml/document';

export function getRssEntries(doc: XMLDocument): RssFeedEntries {
  const entries = [];

  const entryElements = doc.querySelectorAll('item') || [];

  for (const entryElement of entryElements) {
    const url = entryElement.querySelector('link')?.textContent;
    const title = entryElement.querySelector('title')?.textContent;
    const published = entryElement.querySelector('pubDate')?.textContent;

    const entry = {
      url,
      title,
      published
    };

    entries.push(entry);
  }

  return entries;
}