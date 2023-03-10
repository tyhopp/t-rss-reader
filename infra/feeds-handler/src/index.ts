import type { APIGatewayEvent } from 'aws-lambda';
import { verifyToken } from './lib/verify-token';
import { FeedsTable } from './lib/feeds-table';

interface RequestBody {
  url?: string;
  name?: string;
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
  let responseHeaders = headers;

  try {
    const feedsTableInstance = new FeedsTable();

    switch (event.httpMethod) {
      case 'DELETE':
        responseBody = await feedsTableInstance.deleteFeed(requestBody.url);
        break;
      case 'GET':
        responseBody = await feedsTableInstance.getFeeds();
        responseHeaders['Cache-Control'] = `max-age=5`;
        break;
      case 'PUT':
        responseBody = await feedsTableInstance.putFeed(requestBody.url, requestBody.name);
        break;
      default:
        return {
          statusCode: 405,
          body: JSON.stringify({ message: `Unsupported method ${event.httpMethod}` }),
          headers: responseHeaders
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
