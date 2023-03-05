import EntiesService from '../services/entries-service';

class AbortTimeoutController extends AbortController {
  get signal() {
    return AbortSignal.timeout(3000);
  }
}

onmessage = async (event: MessageEvent): Promise<void> => {
  const urls: Array<string> = event.data;
  const controller: AbortController = new AbortTimeoutController();
  const requests = urls.map((url: string) => EntiesService.getEntries(url, controller));
  await Promise.allSettled(requests);
};

export {};
