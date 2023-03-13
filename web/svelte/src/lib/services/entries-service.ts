import { getAccessToken } from '../utils/get-access-token';

export class EntriesService {
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

  async getEntries({
    url,
    abortController,
    timeout
  }: {
    url: string;
    abortController?: AbortController;
    timeout?: number;
  }): Promise<Response> {
    const composedUrl = `${this.api}?url=${encodeURIComponent(url)}`;

    const options: RequestInit = {
      method: 'GET',
      headers: await this.headersWithAuthorization()
    };

    if (abortController) {
      options.signal = abortController.signal;
    }

    let timeoutCallback;

    if (timeout) {
      const timeoutController = new AbortController();
      options.signal = timeoutController.signal;
      timeoutCallback = setTimeout(() => {
        timeoutController.abort();
      }, timeout);
    }

    const response = await fetch(composedUrl, options);

    if (timeoutCallback) {
      clearTimeout(timeoutCallback);
    }

    return response;
  }
}
