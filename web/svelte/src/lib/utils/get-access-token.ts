import { ACCESS_TOKEN_KEY } from '../constants';
import { get } from 'idb-keyval';
import { tokenMaybeValid } from './token-maybe-valid';
import type { Token } from '../types';

export async function getAccessToken(): Promise<string | undefined> {
  return await get(ACCESS_TOKEN_KEY);
}

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
