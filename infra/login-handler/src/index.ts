import { signToken } from './lib/sign-token.js';
import type { APIGatewayEvent } from 'aws-lambda';

export const handler = async (event: APIGatewayEvent) => {
  if (
    !event?.headers?.authorization ||
    event?.headers?.authorization !== process.env.T_RSS_READER_PASSWORD
  ) {
    return {
      statusCode: 401,
      body: JSON.stringify({ message: 'Failed to authorize' }),
      headers: {
        'Content-Type': 'application/json'
      }
    };
  }

  try {
    const { token, expiry } = signToken();

    return {
      statusCode: 200,
      body: JSON.stringify({
        accessToken: token,
        tokenType: 'Bearer',
        expiresIn: expiry
      }),
      headers: {
        'Content-Type': 'application/json',
        'Cache-control': 'no-store'
      }
    };
  } catch (error) {
    console.error(error.message);

    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Failed to create token' }),
      headers: {
        'Content-Type': 'application/json'
      }
    };
  }
};
