import { writable } from 'svelte/store';

export const selectedFeedStore = writable<string | undefined>();
