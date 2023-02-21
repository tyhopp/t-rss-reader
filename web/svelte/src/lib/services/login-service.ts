import { PUBLIC_API_LOGIN } from '$env/static/public';
import type { Message, Token } from '../types';

export class LoginService {
  private get headers(): HeadersInit {
    return {
      'content-type': 'application/json'
    };
  }

  async login(password: string): Promise<Message | Token> {
    const response = await fetch(PUBLIC_API_LOGIN, {
      method: 'POST',
      cache: 'no-cache',
      headers: { ...this.headers, authorization: password }
    });

    return await response.json();
  }
}
