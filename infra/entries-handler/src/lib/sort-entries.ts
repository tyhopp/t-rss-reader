import { LastAccessTable } from './last-access-table';
import { getUnixTime } from './get-unix-time';
import type { RssFeedEntries } from './types';

export async function sortEntries(unsortedEntries: RssFeedEntries) {
  let sortedEntries: RssFeedEntries = unsortedEntries;

  try {
    const lastAccessTableInstance = new LastAccessTable();
    const lastAccessUnixTime = await lastAccessTableInstance.getLastAccess();

    sortedEntries = sortedEntries.map((entry) => {
      const publishedUnixTime = getUnixTime(entry.published);
      entry.isNew = publishedUnixTime > lastAccessUnixTime;
      return entry;
    });

    sortedEntries = unsortedEntries.sort((a, b) => {
      if (a.isNew && b.isNew) {
        return 0;
      }

      if (a.isNew) {
        return -1;
      }

      if (b.isNew) {
        return 1;
      }

      return 0;
    });
  } catch (error) {
    console.error('Failed to sort entries', error);
  }

  return sortedEntries;
}
