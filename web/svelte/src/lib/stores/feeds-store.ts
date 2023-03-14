import { writable } from 'svelte/store';
import { FeedsService } from '../services/feeds-service';
import { Result } from 't-rss-reader';
import type { Feeds } from 't-rss-reader';

const feedsStoreInstance = writable<Feeds>([]);

export const feedsStore = {
  init: async (): Promise<Result> => {
    const response = await FeedsService.getFeeds();

    if (response.status === 200) {
      const nextFeeds = await response.json();

      feedsStoreInstance.set(nextFeeds);

      return Result.success;
    }

    return Result.failure;
  },
  subscribe: feedsStoreInstance.subscribe,
  update: feedsStoreInstance.update
};
