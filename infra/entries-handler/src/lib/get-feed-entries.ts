import { RssFeedFormat } from './types';
import type { RssFeedEntry, RssFeedEntries } from './types';
import type { XMLDocument } from 'linkedom/types/xml/document';
import type { NodeList } from 'linkedom/types/interface/node-list';

function getTextContent(element: Element, selector: string): string | null | undefined {
  return element.querySelector(selector)?.textContent;
}

function getEntry({
  entryElement,
  urlTag,
  publishedTag
}: {
  entryElement: Element;
  urlTag: string;
  publishedTag: string;
}): RssFeedEntry {
  return {
    url: getTextContent(entryElement, urlTag),
    title: getTextContent(entryElement, 'title'),
    published: getTextContent(entryElement, publishedTag)
  };
}

function getEntryElements(doc: XMLDocument, format: RssFeedFormat): NodeList {
  return doc.querySelectorAll(format === RssFeedFormat.rss ? 'item' : 'entry');
}

function getUrlTag(format: RssFeedFormat): string {
  return format === RssFeedFormat.rss ? 'link' : 'id';
}

function getPublishedTag(format: RssFeedFormat): string {
  return format === RssFeedFormat.rss ? 'pubDate' : 'published';
}

export function getFeedEntries(doc: XMLDocument, format: RssFeedFormat): RssFeedEntries {
  const entries = [];

  const entryElements = getEntryElements(doc, format) || [];
  const urlTag = getUrlTag(format);
  const publishedTag = getPublishedTag(format);

  for (const entryElement of entryElements) {
    const entry = getEntry({ entryElement, urlTag, publishedTag });
    entries.push(entry);
  }

  return entries;
}
