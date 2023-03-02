import { PUBLIC_LOGIN_API } from '$env/static/public';

export class LoginServiceImpl {
  private get headers(): HeadersInit {
    return {
      'content-type': 'application/json'
    };
  }

  async login(password: string): Promise<Response> {
    return await fetch(PUBLIC_LOGIN_API, {
      method: 'POST',
      cache: 'no-cache',
      headers: { ...this.headers, authorization: password }
    });
  }
}

const LoginServiceInstance = new LoginServiceImpl();
const LoginServiceSingleton = Object.freeze(LoginServiceInstance);

export default LoginServiceSingleton;
