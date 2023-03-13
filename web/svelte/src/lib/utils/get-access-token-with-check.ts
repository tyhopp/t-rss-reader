import { getAccessToken } from './get-access-token';
import { tokenMaybeValid } from './token-maybe-valid';
import type { Token } from '../types';

export async function getAccessTokenWithCheck(): Promise<{
  maybeValid: boolean;
  token?: Token;
}> {
  try {
    const token = await getAccessToken();

    if (token) {
      const parsedToken: Token = JSON.parse(token) || {};

      return {
        maybeValid: tokenMaybeValid(parsedToken),
        token: parsedToken
      };
    }
  } catch (_) {
    return {
      maybeValid: false
    };
  }

  return {
    maybeValid: false
  };
}
