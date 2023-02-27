import { writable } from 'svelte/store';

interface ModalStore {
  open: boolean;
  editing: boolean;
  name: string | undefined;
  url: string | undefined;
}

const modalStoreInstance = writable<ModalStore>({
  open: false,
  editing: false,
  name: undefined,
  url: undefined
});

export const modalStore = {
  subscribe: modalStoreInstance.subscribe,
  open: ({ editing = false, name, url }: { editing?: boolean; name?: string; url?: string } = {}) =>
    modalStoreInstance.set({
      open: true,
      editing,
      name,
      url
    }),
  close: () =>
    modalStoreInstance.set({
      open: false,
      editing: false,
      name: undefined,
      url: undefined
    }),
  set: modalStoreInstance.set
};
