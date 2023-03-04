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

  async getEntries(url: string, abortController?: AbortController): Promise<Response> {
    const options: RequestInit = {
      method: 'GET',
      headers: this.headersWithAuthorization()
    };

    if (abortController) {
      options.signal = abortController.signal;
    }

    return await fetch(`${PUBLIC_ENTRIES_API}?url=${encodeURIComponent(url)}`, options);
  }
}

const EntriesServiceInstance = new EntriesServiceImpl();
const EntriesServiceSingleton = Object.freeze(EntriesServiceInstance);

export default EntriesServiceSingleton;
