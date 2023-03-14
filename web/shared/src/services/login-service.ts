export class LoginService {
  constructor(api: string) {
    this.api = api;
  }

  api: string;

  private get headers(): HeadersInit {
    return {
      'content-type': 'application/json'
    };
  }

  async login(password: string): Promise<Response> {
    return await fetch(this.api, {
      method: 'POST',
      cache: 'no-cache',
      headers: { ...this.headers, authorization: password }
    });
  }
}
