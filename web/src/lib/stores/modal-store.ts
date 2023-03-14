import { writable } from 'svelte/store';

export enum ModalMode {
  edit = 'edit',
  add = 'add'
}

interface ModalStore {
  open: boolean;
  mode: ModalMode;
  name: string | undefined;
  url: string | undefined;
}

const modalStoreInstance = writable<ModalStore>({
  open: false,
  mode: ModalMode.add,
  name: undefined,
  url: undefined
});

export const modalStore = {
  subscribe: modalStoreInstance.subscribe,
  open: ({
    mode = ModalMode.add,
    name,
    url
  }: { mode?: ModalMode; name?: string; url?: string } = {}) =>
    modalStoreInstance.set({
      open: true,
      mode,
      name,
      url
    }),
  close: () =>
    modalStoreInstance.set({
      open: false,
      mode: ModalMode.add,
      name: undefined,
      url: undefined
    }),
  set: modalStoreInstance.set
};
