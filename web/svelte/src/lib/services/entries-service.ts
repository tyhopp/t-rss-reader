import { getAccessToken } from '../utils/get-access-token';
import { PUBLIC_ENTRIES_API } from '$env/static/public';

export class EntriesServiceImpl {
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

  async getEntries(url: string, abortController?: AbortController): Promise<Response> {
    const options: RequestInit = {
      method: 'GET',
      headers: await this.headersWithAuthorization()
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
