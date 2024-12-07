import { test, expect, vi } from 'vitest';
import { parseFeed } from '../../src/lib/parse-feed';
import { getRssEntries } from '../../src/lib/get-rss-entries';
import { getAtomEntries } from '../../src/lib/get-atom-entries';
import { getFeedFormat } from '../../src/lib/get-feed-format';
import { RssFeedFormat } from '../../src/lib/types';

const url = 'some-url';
const xml = '<some-xml></some-xml>';
const entry = {
  url: 'url',
  title: 'title',
  published: 'published'
};

vi.mock('../../src/lib/get-feed-format', () => ({
  getFeedFormat: vi.fn()
}));

vi.mock('../../src/lib/get-rss-entries', () => ({
  getRssEntries: vi.fn()
}));

vi.mock('../../src/lib/get-atom-entries', () => ({
  getAtomEntries: vi.fn()
}));

test('should error on feeds that are not a known format', () => {
  expect(() => parseFeed(url, xml)).toThrowError(
    `Unable to determine feed format of RSS feed '${url}'.`
  );
});

test('should return rss entries', () => {
  vi.mocked(getFeedFormat).mockReturnValueOnce(RssFeedFormat.rss);
  vi.mocked(getRssEntries).mockReturnValueOnce([entry]);

  const entries = parseFeed(url, xml);

  expect(entries).toEqual([entry]);
});

test('should return atom entries', () => {
  vi.mocked(getFeedFormat).mockReturnValueOnce(RssFeedFormat.atom);
  vi.mocked(getAtomEntries).mockReturnValueOnce([entry]);

  const entries = parseFeed(url, xml);

  expect(entries).toEqual([entry]);
});
