import { test, beforeEach, afterEach, vi, expect } from 'vitest';
import { createEvent } from './fixture/create-event';
import { handler } from '../src/index';

vi.mock('../src/lib/get-timestamp', () => {
  return {
    getTimestamp: () => ({
      now: 1,
      expiry: 2
    })
  };
});

vi.mock('../src/lib/sign-token', () => {
  return {
    signToken: () => ({
      token: 'a',
      expiry: 2
    })
  };
});

const password = 'abc';

beforeEach(() => {
  process.env.T_RSS_READER_PASSWORD = password;
});

afterEach(() => {
  delete process.env.T_RSS_READER_PASSWORD;
});

test('should fail to authorize with no authorization header', async () => {
  const event = createEvent('login', 'POST');
  const { statusCode, body } = await handler(event);

  expect(statusCode).to.equal(401);
  expect(body).to.include('Failed to authorize');
});

test('should fail to authorize with an incorrect authorization header', async () => {
  const event = createEvent('login', 'POST');
  event.headers.authorization = 'incorrect';

  const { statusCode, body } = await handler(event);

  expect(statusCode).to.equal(401);
  expect(body).to.include('Failed to authorize');
});

test('should authorize with a correct authorization header', async () => {
  const event = createEvent('login', 'POST');
  event.headers.authorization = password;

  const { statusCode, body, headers } = await handler(event);
  const { accessToken, tokenType, expiresIn } = JSON.parse(body);

  expect(statusCode).to.equal(200);
  expect(accessToken).to.equal('a');
  expect(tokenType).to.equal('Bearer');
  expect(expiresIn).to.equal(2);
  expect(headers['Cache-control']).to.equal('no-store');
});
