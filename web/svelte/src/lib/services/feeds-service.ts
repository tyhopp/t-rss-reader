import { FEEDS_API, LOCAL_STORAGE_ACCESS_TOKEN_KEY } from '../constants';
import type { Message, Feeds } from '../types';

export class FeedsService {
  private get headers(): HeadersInit {
    return {
      'content-type': 'application/json'
    };
  }

  private headersWithAuthorization(): HeadersInit {
    const token = localStorage.getItem(LOCAL_STORAGE_ACCESS_TOKEN_KEY);

    if (!token) {
      return this.headers;
    }

    const { accessToken } = JSON.parse(token) || {};

    return {
      ...this.headers,
      authorization: accessToken
    };
  }

  async deleteFeed(url: string): Promise<Message> {
    const response = await fetch(FEEDS_API, {
      method: 'DELETE',
      headers: this.headersWithAuthorization(),
      body: JSON.stringify({ url })
    });

    return await response.json();
  }

  async getFeeds(): Promise<Message | { feeds: Feeds }> {
    const response = await fetch(FEEDS_API, {
      method: 'GET',
      headers: this.headersWithAuthorization()
    });

    return await response.json();
  }

  async putFeed(url: string, name: string): Promise<Message> {
    const response = await fetch(FEEDS_API, {
      method: 'PUT',
      headers: this.headersWithAuthorization(),
      body: JSON.stringify({ url, name })
    });

    return await response.json();
  }
}
