import type { Feeds } from '$lib/types';

export function sortFeeds(feeds: Feeds): Feeds {
  return feeds.sort((a, b) => {
    if (a.hasNew && b.hasNew) {
      return a.name.localeCompare(b.name);
    }

    if (a.hasNew) {
      return -1;
    }

    if (b.hasNew) {
      return 1;
    }

    return a.name.localeCompare(b.name);
  });
}
