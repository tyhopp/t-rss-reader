import type { APIGatewayEvent, APIGatewayEventRequestContext } from 'aws-lambda';

const event: APIGatewayEvent = {
  path: 'entries',
  resource: 'entries',
  httpMethod: 'POST',
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

export function createEvent(
  httpMethod: string = 'POST',
  body: Record<string, unknown> = {}
): APIGatewayEvent {
  const stringifiedBody = JSON.stringify(body);
  return { ...event, httpMethod, body: stringifiedBody };
}