import { FEEDS_API, LOCAL_STORAGE_ACCESS_TOKEN_KEY } from '../constants';

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

  async deleteFeed(url: string): Promise<Response> {
    return await fetch(FEEDS_API, {
      method: 'DELETE',
      headers: this.headersWithAuthorization(),
      body: JSON.stringify({ url })
    });
  }

  async getFeeds(): Promise<Response> {
    return await fetch(FEEDS_API, {
      method: 'GET',
      headers: this.headersWithAuthorization()
    });
  }

  async putFeed(url: string, name: string): Promise<Response> {
    return await fetch(FEEDS_API, {
      method: 'PUT',
      headers: this.headersWithAuthorization(),
      body: JSON.stringify({ url, name })
    });
  }
}
