import * as path from 'path';
import * as fs from 'fs';
import { test, expect } from 'vitest';
import { DOMParser } from 'linkedom';
import { getRssEntries } from '../../src/lib/get-rss-entries';

const parser = new DOMParser();

const rssPath = path.resolve(__dirname, '../fixture/rss.xml');
const rssXml = fs.readFileSync(rssPath, 'utf-8');
const rssDoc = parser.parseFromString(rssXml, 'text/xml');
const emptyRssDoc = parser.parseFromString('<rss></rss>', 'text/xml');
const emptyRandomDoc = parser.parseFromString('<hello></hello>', 'text/xml');

const rssEntry = {
  url: 'rss-url',
  title: 'rss-title',
  published: 'rss-published'
};

test('should handle rss feeds', () => {
  const entries = getRssEntries(rssDoc);
  expect(entries).toEqual([rssEntry]);
});

test('should return no rss feed entries if there are none', () => {
  const entries = getRssEntries(emptyRssDoc);
  expect(entries).toEqual([]);
});

test('should return no rss feed entries if the document is not an rss document', () => {
  const entries = getRssEntries(emptyRandomDoc);
  expect(entries).toEqual([]);
});
