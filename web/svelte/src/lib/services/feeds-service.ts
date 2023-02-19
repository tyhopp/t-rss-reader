import { PUBLIC_API_FEEDS } from '$env/static/public';
import { LOCAL_STORAGE_ACCESS_TOKEN_KEY } from '../constants';
import type { ServiceResponse } from '../types';

export class FeedsService {
  get accessToken(): string {
    return localStorage.getItem(LOCAL_STORAGE_ACCESS_TOKEN_KEY) || '';
  }

  get headers(): HeadersInit {
    return {
      'content-type': 'application/json',
      authorization: this.accessToken
    };
  }

  async deleteFeed(url: string): ServiceResponse {
    const response = await fetch(PUBLIC_API_FEEDS, {
      method: 'DELETE',
      headers: this.headers,
      body: JSON.stringify({ url })
    });

    const json = await response.json();

    return json;
  }

  async getFeeds(): ServiceResponse {
    const response = await fetch(PUBLIC_API_FEEDS, {
      method: 'GET',
      headers: this.headers
    });

    const json = await response.json();

    return json;
  }

  async putFeed(url: string, name: string): ServiceResponse {
    const response = await fetch(PUBLIC_API_FEEDS, {
      method: 'PUT',
      headers: this.headers,
      body: JSON.stringify({ url, name })
    });

    const json = await response.json();

    return json;
  }
}
