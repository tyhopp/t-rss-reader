import { RssFeedFormat } from '../types';

export function getFeedFormat(doc: XMLDocument): RssFeedFormat | undefined {
  const tag = doc.firstElementChild?.tagName?.toLowerCase();

  switch (tag) {
    case 'feed':
      return RssFeedFormat.atom;
    case 'rss':
      return RssFeedFormat.rss;
  }
}
