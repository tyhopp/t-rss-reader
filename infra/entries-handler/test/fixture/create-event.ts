import type { APIGatewayEvent, APIGatewayEventRequestContext } from 'aws-lambda';

const event: APIGatewayEvent = {
  path: 'entries',
  resource: 'entries',
  queryStringParameters: {
    url: 'https%3A%2F%2Ftyhopp.com%2Frss.xml'
  },
  httpMethod: 'GET',
  body: '{}',
  headers: {
    'Content-Type': 'application/json'
  },
  multiValueHeaders: {},
  isBase64Encoded: false,
  pathParameters: null,
  multiValueQueryStringParameters: null,
  stageVariables: null,
  requestContext: {} as APIGatewayEventRequestContext
};

export function createEvent(
  queryStringParameters: Record<string, string> = event.queryStringParameters,
  httpMethod: string = 'GET'
): APIGatewayEvent {
  return { ...event, queryStringParameters, httpMethod };
}
