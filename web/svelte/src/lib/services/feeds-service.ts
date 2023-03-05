import { getAccessToken } from '../utils/get-access-token';
import { PUBLIC_FEEDS_API } from '$env/static/public';

export class FeedsServiceImpl {
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

    return await fetch(PUBLIC_FEEDS_API, {
      method: 'DELETE',
      headers,
      body: JSON.stringify({ url })
    });
  }

  async getFeeds(): Promise<Response> {
    const headers = await this.headersWithAuthorization();

    return await fetch(PUBLIC_FEEDS_API, {
      method: 'GET',
      headers
    });
  }

  async putFeed(url: string, name: string): Promise<Response> {
    const headers = await this.headersWithAuthorization();

    return await fetch(PUBLIC_FEEDS_API, {
      method: 'PUT',
      headers,
      body: JSON.stringify({ url, name })
    });
  }
}

const FeedsServiceInstance = new FeedsServiceImpl();
const FeedsServiceSingleton = Object.freeze(FeedsServiceInstance);

export default FeedsServiceSingleton;
