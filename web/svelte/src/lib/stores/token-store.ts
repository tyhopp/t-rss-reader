import { writable } from 'svelte/store';
import { getAccessTokenWithCheck } from '../utils/get-access-token';
import { tokenMaybeValid } from '../utils/token-maybe-valid';
import { ACCESS_TOKEN_KEY } from '../constants';
import { set } from 'idb-keyval';
import type { Token } from '../types';

interface TokenStore {
  maybeValid: boolean;
  token?: Token;
}

const tokenStoreInstance = writable<TokenStore>();

export const tokenStore = {
  init: async (): Promise<boolean> => {
    const { maybeValid, token } = await getAccessTokenWithCheck();
    tokenStoreInstance.set({ maybeValid, token });
    return true;
  },
  subscribe: tokenStoreInstance.subscribe,
  set: async (token: Token) => {
    await set(ACCESS_TOKEN_KEY, JSON.stringify(token));
    const maybeValid = tokenMaybeValid(token);
    tokenStoreInstance.set({ maybeValid, token });
  }
};
