import { PUBLIC_API_LOGIN } from '$env/static/public';
import { LOCAL_STORAGE_ACCESS_TOKEN_KEY } from '../constants';
import type { ServiceResponse } from '../types';

export class LoginService {
  get headers(): HeadersInit {
    return {
      'content-type': 'application/json'
    };
  }

  async login(password: string): ServiceResponse {
    const response = await fetch(PUBLIC_API_LOGIN, {
      method: 'DELETE',
      cache: 'no-cache',
      headers: { ...this.headers, authorization: password }
    });

    const json = await response.json();

    localStorage.set(LOCAL_STORAGE_ACCESS_TOKEN_KEY, JSON.parse(json));

    return json;
  }
}
