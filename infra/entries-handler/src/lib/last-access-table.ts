import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, GetCommand, GetCommandOutput } from '@aws-sdk/lib-dynamodb';

export class LastAccessTable {
  private tableName: string = 't-rss-reader-last-access-table';
  private dbClientInstance: DynamoDBClient;
  private dbDocClientInstance: DynamoDBDocumentClient;
  private id: number = 0;

  constructor() {
    this.dbClientInstance = new DynamoDBClient({});
    this.dbDocClientInstance = DynamoDBDocumentClient.from(this.dbClientInstance);
  }

  async getLastAccess(): Promise<number> {
    let lastAccess: number = Date.now();
    let response: GetCommandOutput;

    try {
      response = await this.dbDocClientInstance.send(
        new GetCommand({
          TableName: this.tableName,
          Key: {
            id: this.id
          }
        })
      );
    } catch (error) {
      console.error('Failed to get last access', error);
    }

    if (response?.Item?.lastAccess) {
      lastAccess = response?.Item?.lastAccess;
    }

    return lastAccess;
  }
}
