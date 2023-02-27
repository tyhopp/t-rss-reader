import type { RssFeedEntry, RssFeedEntries } from '../types';

function extractValue(element: Element, selector: string): string | null | undefined {
  return element.querySelector(selector)?.textContent;
}

function extractFeedEntry(element: Element): RssFeedEntry {
  return {
    id: extractValue(element, 'id'),
    title: extractValue(element, 'title'),
    published: extractValue(element, 'published'),
    updated: extractValue(element, 'updated')
  };
}

export function extractFeedEntries(doc: XMLDocument): RssFeedEntries {
  const entries = [];

  const entryElements = doc.querySelectorAll('entry');

  for (const entryElement of entryElements) {
    const entry = extractFeedEntry(entryElement);
    entries.push(entry);
  }

  return entries;
}
