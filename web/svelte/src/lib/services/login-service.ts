import { LOGIN_API } from '../constants';
import type { Message, Token } from '../types';

export class LoginService {
  private get headers(): HeadersInit {
    return {
      'content-type': 'application/json'
    };
  }

  async login(password: string): Promise<Message | Token> {
    const response = await fetch(LOGIN_API, {
      method: 'POST',
      cache: 'no-cache',
      headers: { ...this.headers, authorization: password }
    });

    return await response.json();
  }
}
