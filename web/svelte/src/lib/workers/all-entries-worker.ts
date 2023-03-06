import EntriesService from '../services/entries-service';
import LastAccessService from '../services/last-access-service';

class AbortTimeoutController extends AbortController {
  get signal() {
    return AbortSignal.timeout(3000);
  }
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
  await Promise.allSettled(requests);

  const lastAccessService: LastAccessService = new LastAccessService(lastAccessApi);
  await lastAccessService.putLastAccess();
};

export {};
