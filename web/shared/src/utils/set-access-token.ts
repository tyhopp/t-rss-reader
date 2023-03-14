import { ACCESS_TOKEN_KEY } from '../constants.js';
import { set } from 'idb-keyval';
import type { Token } from '../types.js';

export async function setAccessToken(token: Token): Promise<void> {
  return await set(ACCESS_TOKEN_KEY, JSON.stringify(token));
}
