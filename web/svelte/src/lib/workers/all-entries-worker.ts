import EntriesService from '../services/entries-service';
import LastAccessService from '../services/last-access-service';
import type { RssFeedEntries } from '$lib/types';

class AbortTimeoutController extends AbortController {
  get signal() {
    return AbortSignal.timeout(3000);
  }
}

function hasNew(entries: RssFeedEntries) {
  return entries.some((entry) => entry?.isNew);
}

onmessage = async (event: MessageEvent): Promise<void> => {
  const {
    entriesApi,
    lastAccessApi,
    urls
  }: { entriesApi: string; lastAccessApi: string; urls: Array<string> } = event.data || {};

  const controller: AbortController = new AbortTimeoutController();
  const entriesService: EntriesService = new EntriesService(entriesApi);
  const requests = urls.map((url: string) => entriesService.getEntries(url, controller));
  const responses = await Promise.allSettled(requests);

  const lastAccessService: LastAccessService = new LastAccessService(lastAccessApi);
  await lastAccessService.putLastAccess();

  postMessage('finished');

  const feedsWithNewEntries: Set<string> = new Set();

  for (const response of responses) {
    if (response.status === 'fulfilled' && response.value) {
      const entries = await response.value.json();

      if (hasNew(entries)) {
        const feed = new URL(response.value.url);
        const url = feed.searchParams.get('url');

        if (url) {
          feedsWithNewEntries.add(url);
        }
      }
    }
  }

  postMessage(feedsWithNewEntries);
};

export {};
