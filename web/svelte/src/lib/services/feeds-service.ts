import { LOCAL_STORAGE_ACCESS_TOKEN_KEY } from '../constants';
import { PUBLIC_FEEDS_API } from '$env/static/public';

export class FeedsServiceImpl {
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
    return await fetch(PUBLIC_FEEDS_API, {
      method: 'DELETE',
      headers: this.headersWithAuthorization(),
      body: JSON.stringify({ url })
    });
  }

  async getFeeds(): Promise<Response> {
    return await fetch(PUBLIC_FEEDS_API, {
      method: 'GET',
      headers: this.headersWithAuthorization()
    });
  }

  async putFeed(url: string, name: string): Promise<Response> {
    return await fetch(PUBLIC_FEEDS_API, {
      method: 'PUT',
      headers: this.headersWithAuthorization(),
      body: JSON.stringify({ url, name })
    });
  }
}

const FeedsServiceInstance = new FeedsServiceImpl();
const FeedsServiceSingleton = Object.freeze(FeedsServiceInstance);

export default FeedsServiceSingleton;
