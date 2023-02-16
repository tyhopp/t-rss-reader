import type { APIGatewayEvent, APIGatewayEventRequestContext } from 'aws-lambda';

const event: Omit<APIGatewayEvent, 'httpMethod' | 'path' | 'resource'> = {
  body: '',
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

export function createEvent(resource: string, httpMethod: string): APIGatewayEvent {
  return { ...event, resource, path: resource, httpMethod };
}
