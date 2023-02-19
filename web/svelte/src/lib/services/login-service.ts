import { PUBLIC_API_LOGIN } from '$env/static/public';

interface LoginServiceResponseBody {
  message?: string;
  accessToken?: string;
  tokenType?: string;
  expiresIn?: number;
}

type LoginServiceResponse = Promise<LoginServiceResponseBody>;

export class LoginService {
  private get headers(): HeadersInit {
    return {
      'content-type': 'application/json'
    };
  }

  async login(password: string): LoginServiceResponse {
    const response = await fetch(PUBLIC_API_LOGIN, {
      method: 'POST',
      cache: 'no-cache',
      headers: { ...this.headers, authorization: password }
    });

    return await response.json();
  }
}
