import type { RssFeedEntries } from './types';
import type { XMLDocument } from 'linkedom/types/xml/document';

export function getAtomEntries(doc: XMLDocument): RssFeedEntries {
  const entries = [];

  const entryElements = doc.querySelectorAll('entry') || [];

  for (const entryElement of entryElements) {
    const url = entryElement.querySelector('link')?.getAttribute('href') ?? entryElement.querySelector('id')?.textContent;
    const title = entryElement.querySelector('title')?.textContent;
    const published = entryElement.querySelector('published, updated')?.textContent;

    const entry = {
      url,
      title,
      published
    };

    entries.push(entry);
  }

  return entries;
}