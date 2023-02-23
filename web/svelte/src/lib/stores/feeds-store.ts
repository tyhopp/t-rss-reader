import { writable } from 'svelte/store';
import { FeedsService } from '../services/feeds-service';
import { LOCAL_STORAGE_FEEDS_CACHE_KEY } from '../constants';
import type { Feed, Feeds } from '../types';

const feedsServiceInstance = new FeedsService();

const feedsStoreInstance = writable<Feeds>([]);

export const feedsStore = {
  loadCache: (): boolean => {
    try {
      const cachedFeeds = localStorage.getItem(LOCAL_STORAGE_FEEDS_CACHE_KEY);

      if (!cachedFeeds) {
        return true;
      }

      const parsedCachedFeeds: Feeds = JSON.parse(cachedFeeds);

      feedsStoreInstance.set(parsedCachedFeeds);

      return true;
    } catch (error) {
      console.warn('Failed to restore cached feeds', { error });
      return true;
    }
  },
  revalidate: async (): Promise<void> => {
    const response = await feedsServiceInstance.getFeeds();

    if (response.status === 200) {
      const nextFeeds = await response.json();

      localStorage.setItem(LOCAL_STORAGE_FEEDS_CACHE_KEY, JSON.stringify(nextFeeds));

      feedsStoreInstance.set(nextFeeds);
    }
  },
  subscribe: feedsStoreInstance.subscribe,
  get: (): Feeds => {
    const cachedFeeds = localStorage.getItem(LOCAL_STORAGE_FEEDS_CACHE_KEY);

    if (!cachedFeeds) {
      return [];
    }

    const parsedCachedFeeds = JSON.parse(cachedFeeds);

    return parsedCachedFeeds;
  },
  add: (feed: Feed): void => {
    feedsStoreInstance.update((prevFeeds) => {
      const nextFeeds = [...prevFeeds, feed];
      localStorage.setItem(LOCAL_STORAGE_FEEDS_CACHE_KEY, JSON.stringify(nextFeeds));
      return nextFeeds;
    });
  }
};
