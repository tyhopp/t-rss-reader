import { AuthorizedService } from './authorized-service';

export class EntriesService extends AuthorizedService {
  constructor(api: string) {
    super();
    this.api = api;
  }

  api: string;

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
      headers: await this.headers()
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
