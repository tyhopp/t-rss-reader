import { afterEach, it } from 'node:test';
import { expect } from 'chai';

import { handler } from './index.mjs';

afterEach(() => {
  delete process.env.T_RSS_READER_PASSWORD;
});

it('should fail to authorize with no authorization header', async () => {
  const { statusCode, body } = await handler({});
  expect(statusCode).to.equal(401);
  expect(body).to.include('Failed to authorize');
});

it('should fail to authorize with an incorrect authorization header', async () => {
  const { statusCode, body } = await handler({ headers: { authorization: 'b' } });
  expect(statusCode).to.equal(401);
  expect(body).to.include('Failed to authorize');
});

it('should authorize with a correct authorization header', async () => {
  const password = 'a';
  process.env.T_RSS_READER_PASSWORD = password;

  const { statusCode, body, headers } = await handler({ headers: { authorization: password } });
  const { accessToken, expiresIn } = JSON.parse(body);

  expect(statusCode).to.equal(200);
  expect(accessToken).to.exist;
  expect(expiresIn).to.exist;
  expect(headers['Cache-control']).to.equal('no-store');
});
