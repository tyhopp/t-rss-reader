import { test, vi, expect } from 'vitest';
import { createEvent } from './fixture/create-event';
import { verifyToken } from '../src/lib/verify-token';
import { handler } from '../src/index';

vi.mock('../src/lib/verify-token', () => ({
  verifyToken: vi.fn()
}));

vi.mock('../src/lib/feeds-table', () => {
  return {
    FeedsTable: class FeedsTable {
      async deleteFeed() {}
      async getFeeds() {
        return { Items: ['https://tyhopp.com/rss.xml'] };
      }
      async putFeed() {}
    }
  };
});

const feedUrl = 'https://tyhopp.com/rss.xml';
const feedName = `Ty Hopp's feed`;

test('should return early if user is not authorized', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(false);
  const event = createEvent('feeds', '');

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(403);
  expect(body).toMatch('Unauthorized');
});

test('should return early if request body is malformed', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('feeds', '');
  event.body = 'invalid-json';

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(400);
  expect(body).toMatch('Malformed request body');
});

test('should handle DELETE requests', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('feeds', 'DELETE');
  event.body = JSON.stringify({ url: feedUrl });

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(200);
  expect(body).toMatch(`Deleted feed ${feedUrl}`);
});

test('should handle GET requests', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('feeds', 'GET');

  const { statusCode, body } = await handler(event);
  const parsedBody = JSON.parse(body);

  expect(statusCode).toEqual(200);
  expect(parsedBody.feeds).toEqual(expect.arrayContaining([feedUrl]));
});

test('should handle PUT requests', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('feeds', 'PUT');
  event.body = JSON.stringify({
    url: feedUrl,
    name: feedName
  });

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(200);
  expect(body).toMatch(`Put feed ${feedUrl}`);
});

test('should reject unsupported methods', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('feeds', 'PATCH');

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(405);
  expect(body).toMatch(`Unsupported method PATCH`);
});
