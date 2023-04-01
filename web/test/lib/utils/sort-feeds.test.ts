import { test, expect } from 'vitest';
import { sortFeeds } from '../../../src/lib/utils/sort-feeds';
import type { Feed } from '../../../src/lib/types';

const feeds: Record<string, Feed> = {
  old: {
    name: 'old',
    url: 'https://example.com',
    hasNew: false
  },
  new: {
    name: 'new',
    url: 'https://example.com',
    hasNew: true
  },
  oldA: {
    name: 'a',
    url: 'https://example.com',
    hasNew: false
  },
  oldB: {
    name: 'b',
    url: 'https://example.com',
    hasNew: false
  },
  newA: {
    name: 'a',
    url: 'https://example.com',
    hasNew: true
  },
  newB: {
    name: 'b',
    url: 'https://example.com',
    hasNew: true
  },
  noHasNewKey: {
    name: 'noHasNewKey',
    url: 'https://example.com'
  }
};

test('should sort feeds by has new', () => {
  const sortedFeeds = sortFeeds([feeds.old, feeds.new, feeds.old]);
  expect(sortedFeeds).toEqual([feeds.new, feeds.old, feeds.old]);
});

test('should sort feeds without new alphabetically', () => {
  const sortedFeeds = sortFeeds([feeds.oldB, feeds.oldA]);
  expect(sortedFeeds).toEqual([feeds.oldA, feeds.oldB]);
});

test('should sort feeds with new alphabetically', () => {
  const sortedFeeds = sortFeeds([feeds.newB, feeds.newA]);
  expect(sortedFeeds).toEqual([feeds.newA, feeds.newB]);
});

test('should sort feeds with new and without new alphabetically', () => {
  const sortedFeeds = sortFeeds([feeds.oldB, feeds.oldA, feeds.newB, feeds.newA]);
  expect(sortedFeeds).toEqual([feeds.newA, feeds.newB, feeds.oldA, feeds.oldB]);
});

test('should sort feeds even if no has new key', () => {
  const sortedFeeds = sortFeeds([feeds.noHasNewKey, feeds.new, feeds.oldA]);
  expect(sortedFeeds).toEqual([feeds.new, feeds.oldA, feeds.noHasNewKey]);
});
