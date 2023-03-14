import { writable } from 'svelte/store';
import type { Feed } from 't-rss-reader';

export const selectedFeedStore = writable<Feed | undefined>();
