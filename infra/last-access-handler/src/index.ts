import { verifyToken } from './lib/verify-token';
import { LastAccessTable } from './lib/last-access-table';
import type { APIGatewayEvent } from 'aws-lambda';

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

  let responseBody: { message: string };

  try {
    const lastAccessTableInstance = new LastAccessTable();

    switch (event.httpMethod) {
      case 'PUT':
        responseBody = await lastAccessTableInstance.putLastAccess();
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
