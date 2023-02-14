import jwt from 'jsonwebtoken';
import dayjs from 'dayjs';

const headers = {
  'Content-Type': 'application/json'
};

export const handler = async (event) => {
  if (
    !event?.headers?.authorization ||
    event?.headers?.authorization !== process.env.T_RSS_READER_PASSWORD
  ) {
    return {
      statusCode: 401,
      body: JSON.stringify({ message: 'Failed to authorize' }),
      headers
    };
  }

  try {
    const now = dayjs();

    /**
     * Disclamer - A long-lived access token is sent. Reasons:
     *
     * - Data stored for this app is not particularly sensitive
     * - Straightforward to revoke access tokens by changing the password
     * - HTTP-only cookies are not convenient for localhost development and non-web based clients
     * - Prefer to keep infra implementation as simple as possible
     *
     * Of course, make your own judgement based on your own requirements. This is acceptable for me for this use case.
     */
    const expiry = now.add(1, 'month');

    const token = jwt.sign(
      {
        iss: 't-rss-reader',
        sub: 'owner',
        iat: now.valueOf(),
        exp: expiry.valueOf()
      },
      process.env.T_RSS_READER_PASSWORD
    );

    return {
      statusCode: 200,
      body: JSON.stringify({
        accessToken: token,
        tokenType: 'Bearer',
        expiresIn: expiry.valueOf()
      }),
      headers: {
        'Cache-control': 'no-store'
      }
    };
  } catch (error) {
    console.error(error.message);

    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to create token' }),
      headers
    };
  }
};
