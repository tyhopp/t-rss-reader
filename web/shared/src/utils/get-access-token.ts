import { ACCESS_TOKEN_KEY } from '../constants.js';
import { get } from 'idb-keyval';

export async function getAccessToken(): Promise<string | undefined> {
  return await get(ACCESS_TOKEN_KEY);
}
