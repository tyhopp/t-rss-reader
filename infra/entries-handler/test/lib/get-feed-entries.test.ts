import * as path from 'path';
import * as fs from 'fs';
import { test, expect } from 'vitest';
import { DOMParser } from 'linkedom';
import { getFeedEntries } from '../../src/lib/get-feed-entries';
import { RssFeedFormat } from '../../src/lib/types';

const parser = new DOMParser();

const atomPath = path.resolve(__dirname, '../fixture/atom.xml');
const rssPath = path.resolve(__dirname, '../fixture/rss.xml');

const atomXml = fs.readFileSync(atomPath, 'utf-8');
const rssXml = fs.readFileSync(rssPath, 'utf-8');

const atomDoc = parser.parseFromString(atomXml, 'text/xml');
const rssDoc = parser.parseFromString(rssXml, 'text/xml');

const emptyAtomDoc = parser.parseFromString('<feed></feed>', 'text/xml');
const emptyRssDoc = parser.parseFromString('<rss></rss>', 'text/xml');
const emptyRandomDoc = parser.parseFromString('<hello></hello>', 'text/xml');

const atomEntry = {
  url: 'atom-url',
  title: 'atom-title',
  published: 'atom-published'
};

const rssEntry = {
  url: 'rss-url',
  title: 'rss-title',
  published: 'rss-published'
};

test('should handle atom feeds', async () => {
  const entries = getFeedEntries(atomDoc, RssFeedFormat.atom);
  expect(entries).toEqual([atomEntry]);
});

test('should handle rss feeds', async () => {
  const entries = getFeedEntries(rssDoc, RssFeedFormat.rss);
  expect(entries).toEqual([rssEntry]);
});

test('should return no atom feed entries if there are none', async () => {
  const entries = getFeedEntries(emptyAtomDoc, RssFeedFormat.atom);
  expect(entries).toEqual([]);
});

test('should return no rss feed entries if there are none', async () => {
  const entries = getFeedEntries(emptyRssDoc, RssFeedFormat.rss);
  expect(entries).toEqual([]);
});

test('should return no atom feed entries if the document is not an atom document', async () => {
  const entries = getFeedEntries(emptyRandomDoc, RssFeedFormat.atom);
  expect(entries).toEqual([]);
});

test('should return no rss feed entries if the document is not an rss document', async () => {
  const entries = getFeedEntries(emptyRandomDoc, RssFeedFormat.rss);
  expect(entries).toEqual([]);
});
