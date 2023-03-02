import { test, vi, expect } from 'vitest';
import { createEvent } from './fixture/create-event';
import { verifyToken } from '../src/lib/verify-token';
import { parseFeed } from '../src/lib/parse-feed';
import { handler } from '../src/index';

const entry = {
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

test('should return early if user is not authorized', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(false);
  const event = createEvent();

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(403);
  expect(body).toMatch('Unauthorized');
});

test('should return early if request body is malformed', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent();
  event.body = 'invalid-json';

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(400);
  expect(body).toMatch('Malformed request body');
});

test('should handle POST requests', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  vi.mocked(parseFeed).mockReturnValueOnce([entry]);
  const event = createEvent('POST', {
    url: ''
  });

  const { statusCode, body } = await handler(event);
  const parsedBody = JSON.parse(body);

  expect(statusCode).toEqual(200);
  expect(parsedBody).toEqual([entry]);
});

test('should reject unsupported methods', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('PATCH', {});

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(405);
  expect(body).toMatch(`Unsupported method PATCH`);
});
