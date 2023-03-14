import { getAccessToken } from '../utils/get-access-token.js';

export class FeedsService {
  constructor(api: string) {
    this.api = api;
  }

  api: string;

  private get headers(): HeadersInit {
    return {
      'content-type': 'application/json'
    };
  }

  private async headersWithAuthorization(): Promise<HeadersInit> {
    const token = await getAccessToken();

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
    const headers = await this.headersWithAuthorization();

    return await fetch(this.api, {
      method: 'DELETE',
      headers,
      body: JSON.stringify({ url })
    });
  }

  async getFeeds(): Promise<Response> {
    const headers = await this.headersWithAuthorization();

    return await fetch(this.api, {
      method: 'GET',
      headers
    });
  }

  async putFeed(url: string, name: string): Promise<Response> {
    const headers = await this.headersWithAuthorization();

    return await fetch(this.api, {
      method: 'PUT',
      headers,
      body: JSON.stringify({ url, name })
    });
  }
}
