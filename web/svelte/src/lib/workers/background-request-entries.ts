import EntriesService from '../services/entries-service';
import LastAccessService from '../services/last-access-service';
import type { RssFeedEntries } from '$lib/types';

type Urls = Array<string>;
type UrlResponseMap = Map<string, PromiseSettledResult<Response>>;

const initialTimeout = 750;
const cutoff = 12000;

function hasNew(entries: RssFeedEntries) {
  return entries.some((entry) => entry?.isNew);
}

async function makeBackgroundRequests(
  urls: Urls,
  entriesService: EntriesService,
  timeout: number
): Promise<UrlResponseMap> {
  const requests = urls.map((url: string) => entriesService.getEntries({ url, timeout }));
  const responses = await Promise.allSettled(requests);

  const urlResponseMap: UrlResponseMap = new Map();

  for (let i = 0; i < urls.length; i++) {
    urlResponseMap.set(urls[i], responses[i]);
  }

  return urlResponseMap;
}

async function notifyFeedsThatHaveNew(urlResponseMap: UrlResponseMap): Promise<Urls> {
  const feedsWithNewEntries: Set<string> = new Set();

  let unfulfilledUrls: Urls = [];

  for (const [url, response] of urlResponseMap) {
    if (response.status !== 'fulfilled') {
      unfulfilledUrls.push(url);
      continue;
    }

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

  if (feedsWithNewEntries) {
    postMessage(feedsWithNewEntries);
  }

  return unfulfilledUrls;
}

/**
 * Request all entries with exponential backoff. Effects are:
 *  - Entries requests are cached so subsequent requests on feed selection are instantaneous
 *  - Feeds can display a new indicator if any entries are new
 */
async function backgroundRequestEntries(
  urls: Urls,
  entriesService: EntriesService,
  timeout: number
): Promise<void> {
  const urlResponseMap = await makeBackgroundRequests(urls, entriesService, timeout);
  const unfulfilledUrls = await notifyFeedsThatHaveNew(urlResponseMap);

  if (unfulfilledUrls.length && timeout <= cutoff) {
    return backgroundRequestEntries(unfulfilledUrls, entriesService, timeout * 2);
  }
}

onmessage = async (event: MessageEvent): Promise<void> => {
  const {
    entriesApi,
    lastAccessApi,
    urls
  }: { entriesApi: string; lastAccessApi: string; urls: Array<string> } = event.data || {};

  const entriesService = new EntriesService(entriesApi);

  await backgroundRequestEntries(urls, entriesService, initialTimeout);

  const lastAccessService: LastAccessService = new LastAccessService(lastAccessApi);
  await lastAccessService.putLastAccess();
};

export {};
