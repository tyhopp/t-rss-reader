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

export type FormResult = 'none' | 'success' | 'failure';

export interface RssFeedEntry {
  id: string | null | undefined;
  title: string | null | undefined;
  published: string | null | undefined;
  updated: string | null | undefined;
}

export type RssFeedEntries = Array<RssFeedEntry>;
