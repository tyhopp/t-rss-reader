import { test, vi, expect } from 'vitest';
import { createEvent } from './fixture/create-event';
import { verifyToken } from '../src/lib/verify-token';
import { handler } from '../src/index';

const lastAccess = 123;

vi.mock('../src/lib/verify-token', () => ({
  verifyToken: vi.fn()
}));

vi.mock('../src/lib/last-access-table', () => {
  return {
    LastAccessTable: class LastAccessTable {
      async putLastAccess() {
        return {
          message: `Successfully put last access: ${lastAccess}`
        };
      }
    }
  };
});

test('should return early if user is not authorized', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(false);
  const event = createEvent('PUT');

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(403);
  expect(body).toMatch('Unauthorized');
});

test('should handle PUT requests', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('PUT');

  const { statusCode, body } = await handler(event);
  const parsedBody = JSON.parse(body);

  expect(statusCode).toEqual(200);
  expect(parsedBody.message).toMatch(`Successfully put last access: ${lastAccess}`);
});

test('should reject unsupported methods', async () => {
  vi.mocked(verifyToken).mockReturnValueOnce(true);
  const event = createEvent('PATCH');

  const { statusCode, body } = await handler(event);

  expect(statusCode).toEqual(405);
  expect(body).toMatch(`Unsupported method PATCH`);
});
