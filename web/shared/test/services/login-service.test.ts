import { test, vi, expect } from 'vitest';
import { LoginService } from '../../src/services/login-service';

const api = 'api';
const password = 'password';

const LoginServiceInstance = new LoginService(api);
const spy = vi.spyOn(LoginServiceInstance, 'login');

vi.stubGlobal('fetch', () => vi.fn());

test('should export a constructor that accepts an api', () => {
  const LoginServiceInstance = new LoginService(api);
  expect(LoginServiceInstance).toBeInstanceOf(LoginService);
  expect(LoginServiceInstance.api).toBe(api);
});

test('should have a login method', () => {
  expect(LoginServiceInstance.login).toBeTypeOf('function');
});

test('should call the login method with password', async () => {
  await LoginServiceInstance.login(password);
  expect(spy).toHaveBeenCalledWith(password);
});
