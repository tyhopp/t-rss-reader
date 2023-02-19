import { PUBLIC_API_FEEDS } from '$env/static/public';
import { LOCAL_STORAGE_ACCESS_TOKEN_KEY } from '../constants';
import type { Feed } from '../types';

interface FeedsServiceResponseBody {
  message?: string;
  feeds?: Array<Feed>;
}

type FeedsServiceResponse = Promise<FeedsServiceResponseBody>;

export class FeedsService {
  private get accessToken(): string {
    return localStorage.getItem(LOCAL_STORAGE_ACCESS_TOKEN_KEY) || '';
  }

  private get headers(): HeadersInit {
    return {
      'content-type': 'application/json',
      authorization: this.accessToken
    };
  }

  async deleteFeed(url: string): FeedsServiceResponse {
    const response = await fetch(PUBLIC_API_FEEDS, {
      method: 'DELETE',
      headers: this.headers,
      body: JSON.stringify({ url })
    });

    return await response.json();
  }

  async getFeeds(): FeedsServiceResponse {
    const response = await fetch(PUBLIC_API_FEEDS, {
      method: 'GET',
      headers: this.headers
    });

    return await response.json();
  }

  async putFeed(url: string, name: string): FeedsServiceResponse {
    const response = await fetch(PUBLIC_API_FEEDS, {
      method: 'PUT',
      headers: this.headers,
      body: JSON.stringify({ url, name })
    });

    return await response.json();
  }
}
