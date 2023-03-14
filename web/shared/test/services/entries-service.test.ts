import { test, vi, expect } from 'vitest';
import { EntriesService } from '../../src/services/entries-service';

const api = 'a';

vi.stubGlobal('fetch', () => vi.fn());

vi.mock('../../src/utils/get-access-token', () => ({
  getAccessToken: vi.fn()
}));

test('should export a constructor that accepts an api', () => {
  const EntriesServiceInstance = new EntriesService(api);
  expect(EntriesServiceInstance).toBeInstanceOf(EntriesService);
  expect(EntriesServiceInstance.api).toBe(api);
});

test('should have a getEntries method', () => {
  const EntriesServiceInstance = new EntriesService(api);
  expect(EntriesServiceInstance.getEntries).toBeTypeOf('function');
});

test('should call the getEntries method with arguments', async () => {
  const EntriesServiceInstance = new EntriesService(api);

  const spy = vi.spyOn(EntriesServiceInstance, 'getEntries');

  const args = {
    url: 'a',
    abortController: new AbortController(),
    timeout: 0
  };

  await EntriesServiceInstance.getEntries(args);

  expect(spy).toHaveBeenCalledWith(args);
});
