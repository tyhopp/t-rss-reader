import { writable } from 'svelte/store';
import { FeedsService } from '../services/feeds-service';
import { Result } from '../types';
import type { Feed, Feeds } from '../types';

const feedsServiceInstance = new FeedsService();

const feedsStoreInstance = writable<Feeds>([]);

export const feedsStore = {
  init: async (): Promise<Result> => {
    const response = await feedsServiceInstance.getFeeds();

    if (response.status === 200) {
      const nextFeeds = await response.json();

      feedsStoreInstance.set(nextFeeds);

      return Result.success;
    }

    return Result.failure;
  },
  subscribe: feedsStoreInstance.subscribe,
  add: (feed: Feed): void => {
    feedsStoreInstance.update((prevFeeds) => {
      const nextFeeds = [...prevFeeds, feed];
      return nextFeeds;
    });
  }
};
