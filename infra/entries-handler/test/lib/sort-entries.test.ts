import { test, vi, expect } from 'vitest';
import { sortEntries } from '../../src/lib/sort-entries';
import { getUnixTime } from '../../src/lib/get-unix-time';
import type { RssFeedEntries } from '../../src/lib/types';

const lastAccess = 1;

const unsortedEntries: RssFeedEntries = [
  {
    url: 'a-url',
    title: 'a-title',
    published: ''
  },
  {
    url: 'b-url',
    title: 'b-title',
    published: ''
  }
];

vi.mock('../../src/lib/get-unix-time', () => {
  return {
    getUnixTime: vi.fn()
  };
});

vi.mock('../../src/lib/last-access-table', () => {
  return {
    LastAccessTable: class LastAccessTable {
      async getLastAccess() {
        return lastAccess;
      }
    }
  };
});

test('should sort entries with different publish times by new first', async () => {
  vi.mocked(getUnixTime).mockReturnValueOnce(0); // First entry published key mock
  vi.mocked(getUnixTime).mockReturnValueOnce(2); // Second entry published key mock

  const [firstEntry, secondEntry] = await sortEntries(unsortedEntries);

  expect(firstEntry.url).toEqual('b-url');
  expect(firstEntry.isNew).toEqual(true);
  expect(secondEntry.url).toEqual('a-url');
  expect(secondEntry.isNew).toEqual(false);
});

test('should leave the same entry order on error', async () => {
  // Not mocking `getUnixTime` will throw an error since the published key is an empty string for entries

  const [firstEntry, secondEntry] = await sortEntries(unsortedEntries);

  expect(firstEntry).toEqual(unsortedEntries[0]);
  expect(secondEntry).toEqual(unsortedEntries[1]);
});
