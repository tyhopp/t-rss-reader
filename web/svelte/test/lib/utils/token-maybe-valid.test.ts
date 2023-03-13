import { test, vi, expect } from 'vitest';
import { tokenMaybeValid } from '../../../src/lib/utils/token-maybe-valid';

vi.useFakeTimers();
vi.setSystemTime(1);

test('should return not valid if no access token', () => {
  const valid = tokenMaybeValid({ accessToken: '', tokenType: 'jwt', expiresIn: 2 });
  expect(valid).toEqual(false);
});

test('should return not valid if past expiry', () => {
  const valid = tokenMaybeValid({ accessToken: 'a', tokenType: 'jwt', expiresIn: 0 });
  expect(valid).toEqual(false);
});

test('should return valid if there is access token and not past expiry', () => {
  const valid = tokenMaybeValid({ accessToken: 'a', tokenType: 'jwt', expiresIn: 2 });
  expect(valid).toEqual(true);
});
