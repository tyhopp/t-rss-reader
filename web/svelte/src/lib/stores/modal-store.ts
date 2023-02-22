import { writable } from 'svelte/store';

const modalStoreInstance = writable(false);

export const modalStore = {
  subscribe: modalStoreInstance.subscribe,
  toggle: () => modalStoreInstance.update((current) => !current)
};
