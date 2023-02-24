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

export interface RssFeedEntry {
  id: string | null | undefined;
  title: string | null | undefined;
  published: string | null | undefined;
  updated: string | null | undefined;
}

export type RssFeedEntries = Array<RssFeedEntry>;
