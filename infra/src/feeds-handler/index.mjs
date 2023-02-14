import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
  DeleteCommand
} from '@aws-sdk/lib-dynamodb';
import jwt from 'jsonwebtoken';

const client = new DynamoDBClient({});

const dynamo = DynamoDBDocumentClient.from(client);

const tableName = 't-rss-reader-feeds-table';

const headers = {
  'Content-Type': 'application/json'
};

export const handler = async (event) => {
  try {
    jwt.verify(event.headers?.authorization, process.env.T_RSS_READER_PASSWORD);
  } catch (_) {
    return {
      statusCode: 403,
      body: JSON.stringify({ message: 'Unauthorized' }),
      headers
    };
  }

  const requestBody = JSON.parse(event.body);

  let responseBody = {};

  try {
    switch (event.httpMethod) {
      case 'DELETE':
        await dynamo.send(
          new DeleteCommand({
            TableName: tableName,
            Key: {
              url: requestBody.url
            }
          })
        );
        responseBody = { message: `Deleted item ${requestBody.url}` };
        break;
      case 'GET':
        responseBody = await dynamo.send(new ScanCommand({ TableName: tableName }));
        responseBody = responseBody.Items;
        break;
      case 'PUT':
        await dynamo.send(
          new PutCommand({
            TableName: tableName,
            Item: {
              url: requestBody.url,
              name: requestBody.name,
              updatedAt: Date.now()
            }
          })
        );
        responseBody = { message: `Put item ${requestBody.url}` };
        break;
      default:
        throw new Error(`Unsupported method: "${event.httpMethod}"`);
    }
  } catch (err) {
    console.error(err.message);

    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Operation failed' }),
      headers
    };
  }

  return {
    statusCode: 200,
    body: JSON.stringify(responseBody),
    headers
  };
};
