import { RssFeedFormat } from './types';
import type { XMLDocument } from 'linkedom/types/xml/document';

export function getFeedFormat(doc: XMLDocument): RssFeedFormat | undefined {
  const tag = doc.firstElementChild?.tagName?.toLowerCase();

  switch (tag) {
    case 'feed':
      return RssFeedFormat.atom;
    case 'rss':
      return RssFeedFormat.rss;
  }
}
