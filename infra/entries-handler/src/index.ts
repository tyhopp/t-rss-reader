import { verifyToken } from './lib/verify-token';
import { parseFeed } from './lib/parse-feed';
import type { APIGatewayEvent } from 'aws-lambda';

const headers = {
  'Content-Type': 'application/json'
};

const minuteInSeconds = 60;
const monthInSeconds = minuteInSeconds * 60 * 24 * 7 * 4;

export const handler = async (event: APIGatewayEvent) => {
  const verified = verifyToken(event?.headers?.authorization);

  if (!verified) {
    return {
      statusCode: 403,
      body: JSON.stringify({ message: 'Unauthorized' }),
      headers
    };
  }

  let url: string;

  try {
    url = decodeURI(event.queryStringParameters.url);
  } catch (error) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Malformed url query parameter' }),
      headers
    };
  }

  let responseBody = {};
  let responseHeaders = headers;

  try {
    switch (event.httpMethod) {
      case 'GET':
        const response = await fetch(url);

        if (response.status >= 400) {
          return {
            statusCode: 400,
            body: JSON.stringify({ message: `Failed to fetch feed ${url}` })
          };
        }

        const xml = await response.text();

        responseBody = parseFeed(url, xml);
        responseHeaders[
          'Cache-Control'
        ] = `max-age=${minuteInSeconds}, stale-while-revalidate=${monthInSeconds}`;
        break;
      default:
        return {
          statusCode: 405,
          body: JSON.stringify({ message: `Unsupported method ${event.httpMethod}` }),
          headers
        };
    }

    return {
      statusCode: 200,
      body: JSON.stringify(responseBody),
      headers: responseHeaders
    };
  } catch (err) {
    console.error(err.message);

    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Operation failed' }),
      headers: responseHeaders
    };
  }
};
