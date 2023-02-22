import { LOGIN_API } from '../constants';

export class LoginService {
  private get headers(): HeadersInit {
    return {
      'content-type': 'application/json'
    };
  }

  async login(password: string): Promise<Response> {
    return await fetch(LOGIN_API, {
      method: 'POST',
      cache: 'no-cache',
      headers: { ...this.headers, authorization: password }
    });
  }
}
