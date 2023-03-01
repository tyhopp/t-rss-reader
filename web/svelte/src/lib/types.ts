export interface Feed {
  name: string;
  url: string;
}

export type Feeds = Array<Feed>;

export interface Token {
  accessToken: string;
  tokenType: string;
  expiresIn: number;
}

export enum Result {
  none = 'none',
  success = 'success',
  failure = 'failure'
}

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
