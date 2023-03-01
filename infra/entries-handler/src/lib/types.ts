export enum RssFeedFormat {
  rss = 'rss',
  atom = 'atom'
}

export interface RssFeedEntry {
  url: string | null | undefined;
  title: string | null | undefined;
  published: string | null | undefined;
}

export type RssFeedEntries = Array<RssFeedEntry>;
