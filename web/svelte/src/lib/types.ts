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

export interface Message {
  message: string;
}

export type FormResult = 'none' | 'success' | 'failure';
