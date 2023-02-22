import { test, vi, expect } from 'vitest';
import { createEvent } from './fixture/create-event';
import { verifyToken } from '../src/lib/verify-token';
import { handler } from '../src/index';

const feedUrl = 'https://tyhopp.com/rss.xml';
const feedName = `Ty Hopp's feed`;
const feed = {
  name: feedName,
  url: feedUrl,
  createdAt: 123,
  updatedAt: 123
};

vi.mock('../src/lib/verify-token', () => ({
  verifyToken: vi.fn()
}));

vi.mock('../src/lib/feeds-table', () => {
  return {
    FeedsTable: class FeedsTable {
      async deleteFeed() {
        return {
          message: `Successfully deleted ${feedUrl}`
        };
      }
      async getFeeds() {
        return [feed];
      }
      async putFeed() {
        return {
          message: `Successfully put ${feedUrl}`,
          feed
        };
      }
    }
  };
});

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
  const { message } = JSON.parse(body);

  expect(statusCode).toEqual(200);
  expect(message).toMatch(`Successfully deleted ${feedUrl}`);
});

test('should handle GET requests', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('feeds', 'GET');

  const { statusCode, body } = await handler(event);
  const parsedBody = JSON.parse(body);

  expect(statusCode).toEqual(200);
  expect(parsedBody).toEqual([feed]);
});

test('should handle PUT requests', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('feeds', 'PUT');
  event.body = JSON.stringify({
    url: feedUrl,
    name: feedName
  });

  const { statusCode, body } = await handler(event);
  const parsedBody = JSON.parse(body);

  expect(statusCode).toEqual(200);
  expect(parsedBody.message).toMatch(`Successfully put ${feedUrl}`);
  expect(parsedBody.feed).toEqual(feed);
});

test('should reject unsupported methods', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('feeds', 'PATCH');

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(405);
  expect(body).toMatch(`Unsupported method PATCH`);
});
