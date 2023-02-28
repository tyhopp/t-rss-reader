import { writable } from 'svelte/store';
import type { Feed } from '../types';

export const selectedFeedStore = writable<Feed | undefined>();
