import EntriesService from '../services/entries-service';

class AbortTimeoutController extends AbortController {
  get signal() {
    return AbortSignal.timeout(3000);
  }
}

onmessage = async (event: MessageEvent): Promise<void> => {
  const { api, urls }: { api: string; urls: Array<string> } = event.data || {};
  const controller: AbortController = new AbortTimeoutController();
  const service: EntriesService = new EntriesService(api);
  const requests = urls.map((url: string) => service.getEntries(url, controller));
  await Promise.allSettled(requests);
};

export {};
