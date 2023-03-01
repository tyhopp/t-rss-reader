import { verifyToken } from './lib/verify-token';
import { parseFeed } from './lib/parse-feed';
import type { APIGatewayEvent } from 'aws-lambda';

interface RequestBody {
  url?: string;
}

const headers = {
  'Content-Type': 'application/json'
};

export const handler = async (event: APIGatewayEvent) => {
  const verified = verifyToken(event?.headers?.authorization);

  if (!verified) {
    return {
      statusCode: 403,
      body: JSON.stringify({ message: 'Unauthorized' }),
      headers
    };
  }

  let requestBody: RequestBody;

  try {
    requestBody = JSON.parse(event.body);
  } catch (error) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Malformed request body' }),
      headers
    };
  }

  let responseBody = {};

  try {
    switch (event.httpMethod) {
      case 'GET':
        const response = await fetch(requestBody.url);

        if (response.status >= 400) {
          return {
            statusCode: 400,
            body: JSON.stringify({ message: `Failed to fetch feed ${requestBody.url}` })
          };
        }

        const xml = await response.text();

        responseBody = parseFeed(requestBody.url, xml);
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
      headers
    };
  } catch (err) {
    console.error(err.message);

    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Operation failed' }),
      headers
    };
  }
};
