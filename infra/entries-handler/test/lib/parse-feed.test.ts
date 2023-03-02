import { test, expect, vi } from 'vitest';
import { parseFeed } from '../../src/lib/parse-feed';
import { getFeedEntries } from '../../src/lib/get-feed-entries';
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

vi.mock('../../src/lib/get-feed-entries', () => ({
  getFeedEntries: vi.fn()
}));

test('should error on feeds that are not a known format', () => {
  expect(() => parseFeed(url, xml)).toThrowError(
    `Unable to determine feed format of RSS feed '${url}'.`
  );
});

test('should return entries', () => {
  vi.mocked(getFeedFormat).mockReturnValueOnce(RssFeedFormat.atom);
  vi.mocked(getFeedEntries).mockReturnValueOnce([entry]);

  const entries = parseFeed(url, xml);

  expect(entries).toEqual([entry]);
});
