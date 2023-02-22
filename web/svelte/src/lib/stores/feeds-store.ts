import { writable } from 'svelte/store';
import { FeedsService } from '../services/feeds-service';
import { LOCAL_STORAGE_FEEDS_CACHE_KEY } from '../constants';
import type { Feed, Feeds } from '../types';

const feedsServiceInstance = new FeedsService();

const feedsStoreInstance = writable<Feeds>([]);

function restoreCachedFeeds(): boolean {
  try {
    const cachedFeeds = localStorage.getItem(LOCAL_STORAGE_FEEDS_CACHE_KEY);

    if (!cachedFeeds) {
      return false;
    }

    const parsedCachedFeeds: Feeds = JSON.parse(cachedFeeds);

    feedsStoreInstance.set(parsedCachedFeeds);

    return true;
  } catch (error) {
    console.warn('Failed to restore cached feeds', { error });
    return false;
  }
}

export const feedsStore = {
  init: async () => {
    const restored = restoreCachedFeeds();

    const response = await feedsServiceInstance.getFeeds();

    if (response.status === 200) {
      const nextFeeds = await response.json();

      if (!restored) {
        localStorage.setItem(LOCAL_STORAGE_FEEDS_CACHE_KEY, JSON.stringify(nextFeeds));
      }

      feedsStoreInstance.set(nextFeeds);
    }
  },
  subscribe: feedsStoreInstance.subscribe,
  add: (feed: Feed) => {
    feedsStoreInstance.update((prevFeeds) => {
      const nextFeeds = [...prevFeeds, feed];
      localStorage.setItem(LOCAL_STORAGE_FEEDS_CACHE_KEY, JSON.stringify(nextFeeds));
      return nextFeeds;
    });
  }
};
