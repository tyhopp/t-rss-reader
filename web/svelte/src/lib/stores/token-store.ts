import { writable } from 'svelte/store';
import { getAccessTokenWithCheck } from 't-rss-reader/utils/get-access-token-with-check';
import { setAccessToken } from 't-rss-reader/utils/set-access-token';
import { tokenMaybeValid } from 't-rss-reader/utils/token-maybe-valid';
import type { Token } from 't-rss-reader';

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
    await setAccessToken(token);
    const maybeValid = tokenMaybeValid(token);
    tokenStoreInstance.set({ maybeValid, token });
  }
};
