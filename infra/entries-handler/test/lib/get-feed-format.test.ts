import * as path from 'path';
import * as fs from 'fs';
import { test, expect } from 'vitest';
import { DOMParser } from 'linkedom';
import { getFeedFormat } from '../../src/lib/get-feed-format';
import { RssFeedFormat } from '../../src/lib/types';

const parser = new DOMParser();

const atomPath = path.resolve(__dirname, '../fixture/atom.xml');
const rssPath = path.resolve(__dirname, '../fixture/rss.xml');

const atomXml = fs.readFileSync(atomPath, 'utf-8');
const rssXml = fs.readFileSync(rssPath, 'utf-8');

const atomDoc = parser.parseFromString(atomXml, 'text/xml');
const rssDoc = parser.parseFromString(rssXml, 'text/xml');

const randomDoc = parser.parseFromString('<hello></hello>', 'text/xml');

test('should identify atom feeds', async () => {
  const format = getFeedFormat(atomDoc);
  expect(format).toEqual(RssFeedFormat.atom);
});

test('should identify rss feeds', async () => {
  const format = getFeedFormat(rssDoc);
  expect(format).toEqual(RssFeedFormat.rss);
});

test('should not identify unknown feeds', async () => {
  const format = getFeedFormat(randomDoc);
  expect(format).toEqual(undefined);
});
