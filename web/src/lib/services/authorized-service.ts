import { getAccessToken } from '../utils/get-access-token';

export class AuthorizedService {
  protected get defaultHeaders(): HeadersInit {
    return {
      'content-type': 'application/json'
    };
  }

  protected async headers(): Promise<HeadersInit> {
    const token = await getAccessToken();

    if (!token) {
      return this.defaultHeaders;
    }

    const { accessToken } = JSON.parse(token) || {};

    return {
      ...this.defaultHeaders,
      authorization: accessToken
    };
  }
}
