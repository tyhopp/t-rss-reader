import { EntriesService } from 't-rss-reader/services/entries-service';
import { LastAccessService } from 't-rss-reader/services/last-access-service';
import type { RssFeedEntries } from 't-rss-reader';

function hasNew(entries: RssFeedEntries) {
  return entries.some((entry) => entry?.isNew);
}

/**
 * Request all entries in the background.
 *  - Entries requests are cached so subsequent requests on feed selection are instantaneous
 *  - Feeds can display a new indicator if any entries are new
 */
async function makeBackgroundRequests(
  urls: Array<string>,
  entriesService: EntriesService
): Promise<void> {
  const requests = urls.map((url: string) =>
    entriesService
      .getEntries({ url, timeout: 10000 })
      .then((response) => response.json())
      .then((entries) => {
        if (hasNew(entries)) {
          postMessage(url);
        }
      })
  );

  await Promise.allSettled(requests);
}

onmessage = async (event: MessageEvent): Promise<void> => {
  const {
    entriesApi,
    lastAccessApi,
    urls
  }: { entriesApi: string; lastAccessApi: string; urls: Array<string> } = event.data || {};

  const entriesService = new EntriesService(entriesApi);

  await makeBackgroundRequests(urls, entriesService);

  const lastAccessService: LastAccessService = new LastAccessService(lastAccessApi);
  await lastAccessService.putLastAccess();
};

export {};
