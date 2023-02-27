import type { Token } from '../types';

/**
 * Best effort guess that a token is valid prior to making a network request.
 */
export function tokenMaybeValid(token: Token): boolean {
  return !!token.accessToken && token.expiresIn > Date.now();
}
