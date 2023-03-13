import { test, vi, expect } from 'vitest';
import LoginServiceInstance, { LoginService } from '../../../src/lib/services/login-service';

vi.stubGlobal('fetch', () => vi.fn());

const spy = vi.spyOn(LoginServiceInstance, 'login');

const password = 'a';

test('should have a default export of a constructed instance', () => {
  expect(LoginServiceInstance).toBeInstanceOf(LoginService);
});

test('should have a login method', () => {
  expect(LoginServiceInstance.login).toBeTypeOf('function');
});

test('should call the login method with password', async () => {
  await LoginServiceInstance.login(password);
  expect(spy).toHaveBeenCalledWith(password);
});
