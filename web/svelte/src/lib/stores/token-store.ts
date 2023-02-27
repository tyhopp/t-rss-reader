import { writable } from 'svelte/store';
import { getAccessToken } from '../utils/get-access-token';
import { tokenMaybeValid } from '../utils/token-maybe-valid';
import { LOCAL_STORAGE_ACCESS_TOKEN_KEY } from '../constants';
import type { Token } from '../types';

interface TokenStore {
  maybeValid: boolean;
  token?: Token;
}

const { maybeValid, token } = getAccessToken();

const tokenStoreInstance = writable<TokenStore>({ maybeValid, token });

export const tokenStore = {
  subscribe: tokenStoreInstance.subscribe,
  set: (token: Token) => {
    localStorage.setItem(LOCAL_STORAGE_ACCESS_TOKEN_KEY, JSON.stringify(token));
    const maybeValid = tokenMaybeValid(token);
    tokenStoreInstance.set({ maybeValid, token });
  }
};
