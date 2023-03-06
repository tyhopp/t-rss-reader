import { getAccessToken } from '../utils/get-access-token';

/**
 * This service does not export a singleton because it is also used in a
 * worker context that does not have access to env vars.
 *
 * Instead the endpoint should be provided when the service is constructed.
 */
export default class LastAccessService {
  constructor(api: string) {
    this.api = api;
  }

  private api: string;

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

  async putLastAccess(): Promise<Response> {
    const options: RequestInit = {
      method: 'PUT',
      headers: await this.headersWithAuthorization()
    };

    return await fetch(this.api, options);
  }
}
