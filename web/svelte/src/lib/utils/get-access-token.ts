import { LOCAL_STORAGE_ACCESS_TOKEN_KEY } from '../constants';
import { tokenMaybeValid } from './token-maybe-valid';
import type { Token } from '../types';

export function getAccessToken(): {
  maybeValid: boolean;
  token?: Token;
} {
  try {
    const token = localStorage.getItem(LOCAL_STORAGE_ACCESS_TOKEN_KEY);

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
