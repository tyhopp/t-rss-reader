import { LOCAL_STORAGE_ACCESS_TOKEN_KEY } from '../constants';
import { PUBLIC_ENTRIES_API } from '$env/static/public';

export class EntriesServiceImpl {
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

  async getEntries(url: string): Promise<Response> {
    return await fetch(PUBLIC_ENTRIES_API, {
      method: 'POST',
      headers: this.headersWithAuthorization(),
      body: JSON.stringify({
        url
      })
    });
  }
}

const EntriesServiceInstance = new EntriesServiceImpl();
const EntriesServiceSingleton = Object.freeze(EntriesServiceInstance);

export default EntriesServiceSingleton;
