import { test, vi, expect } from 'vitest';
import { createEvent } from './fixture/create-event';
import { verifyToken } from '../src/lib/verify-token';
import { handler } from '../src/index';
import { sortEntries } from '../src/lib/sort-entries';
import type { RssFeedEntry } from '../src/lib/types';

const entry: RssFeedEntry = {
  url: 'url',
  title: 'title',
  published: 'published'
};

vi.stubGlobal('fetch', async () => ({
  status: 200,
  text: async () => ''
}));

vi.mock('../src/lib/verify-token', () => ({
  verifyToken: vi.fn()
}));

vi.mock('../src/lib/parse-feed', () => ({
  parseFeed: vi.fn()
}));

vi.mock('../src/lib/sort-entries', () => ({
  sortEntries: vi.fn()
}));

test('should return early if user is not authorized', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(false);
  const event = createEvent();

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(403);
  expect(body).toMatch('Unauthorized');
});

test('should return early if url query param is malformed', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent({ url: '%' });

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(400);
  expect(body).toMatch('Malformed url query parameter');
});

test('should handle GET requests', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  vi.mocked(sortEntries).mockResolvedValueOnce([entry]);
  const event = createEvent();

  const { statusCode, body } = await handler(event);
  const parsedBody = JSON.parse(body);

  expect(statusCode).toEqual(200);
  expect(parsedBody).toEqual([entry]);
});

test('should reject unsupported methods', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent(undefined, 'PATCH');

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(405);
  expect(body).toMatch(`Unsupported method PATCH`);
});
