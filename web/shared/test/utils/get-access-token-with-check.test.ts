import { test, vi, expect } from 'vitest';
import { getAccessTokenWithCheck } from '../../src/utils/get-access-token-with-check';
import { getAccessToken } from '../../src/utils/get-access-token';
import { tokenMaybeValid } from '../../src/utils/token-maybe-valid';

vi.mock('../../src/utils/get-access-token', () => ({
  getAccessToken: vi.fn()
}));

vi.mock('../../src/utils/token-maybe-valid', () => ({
  tokenMaybeValid: vi.fn()
}));

const token = {
  a: 1
};

test('should return not valid if no token', async () => {
  vi.mocked(getAccessToken).mockResolvedValueOnce(undefined);

  const result = await getAccessTokenWithCheck();

  expect(result).toEqual({ maybeValid: false });
});

test('should return not valid if token access fails', async () => {
  vi.mocked(getAccessToken).mockRejectedValueOnce(new Error('some-error'));

  const result = await getAccessTokenWithCheck();

  expect(result).toEqual({ maybeValid: false });
});

test('should return not valid if token may not be valid', async () => {
  vi.mocked(getAccessToken).mockResolvedValueOnce(JSON.stringify(token));
  vi.mocked(tokenMaybeValid).mockReturnValueOnce(false);

  const result = await getAccessTokenWithCheck();

  expect(result).toEqual({ maybeValid: false, token });
});

test('should return valid if token may be valid', async () => {
  vi.mocked(getAccessToken).mockResolvedValueOnce(JSON.stringify(token));
  vi.mocked(tokenMaybeValid).mockReturnValueOnce(true);

  const result = await getAccessTokenWithCheck();

  expect(result).toEqual({ maybeValid: true, token });
});
