import { getAccessToken } from './get-access-token.js';
import { tokenMaybeValid } from './token-maybe-valid.js';
import type { Token } from '../types.js';

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
