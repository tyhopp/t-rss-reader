import jwt from 'jsonwebtoken';
import dayjs from 'dayjs';
import utc from 'dayjs/plugin/utc.js';

dayjs.extend(utc);

const headers = {
  'Content-Type': 'application/json'
};

export const handler = async (event) => {
  if (
    !event.headers?.authorization ||
    event.headers.authorization !== process.env.T_RSS_READER_PASSWORD
  ) {
    statusCode = 401;
    body = 'Unauthorized';

    return {
      statusCode,
      body,
      headers
    };
  }

  try {
    const now = dayjs();
    const expiry = now.add(1, 'month');
    const expiryHeader = `${expiry.utc().format('ddd, D MMM YYYY hh:mm:ss')} GMT`;

    const token = jwt.sign(
      {
        iss: 't-rss-reader',
        sub: 'owner',
        aud: ['all'],
        iat: now.unix(),
        exp: expiry.unix()
      },
      process.env.T_RSS_READER_PASSWORD
    );

    return {
      statusCode: 200,
      body: 'Authorized',
      headers: {
        ...headers,
        'Set-Cookie': `t-rss-reader-token=${token}; HttpOnly; Secure; Expires=${expiryHeader}`
      }
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: 'Failed to create token',
      headers
    };
  }
};
