import type { APIGatewayEvent, APIGatewayEventRequestContext } from 'aws-lambda';

const event: Omit<APIGatewayEvent, 'httpMethod'> = {
  resource: 'last-access',
  path: 'last-access',
  body: '{}',
  headers: {
    'Content-Type': 'application/json'
  },
  multiValueHeaders: {},
  isBase64Encoded: false,
  pathParameters: null,
  queryStringParameters: null,
  multiValueQueryStringParameters: null,
  stageVariables: null,
  requestContext: {} as APIGatewayEventRequestContext
};

export function createEvent(httpMethod): APIGatewayEvent {
  return { ...event, httpMethod };
}
