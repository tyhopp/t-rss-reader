import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand } from '@aws-sdk/lib-dynamodb';

export class LastAccessTable {
  private tableName: string = 't-rss-reader-last-access-table';
  private dbClientInstance: DynamoDBClient;
  private dbDocClientInstance: DynamoDBDocumentClient;
  private id: number = 0;

  constructor() {
    this.dbClientInstance = new DynamoDBClient({});
    this.dbDocClientInstance = DynamoDBDocumentClient.from(this.dbClientInstance);
  }

  async putLastAccess(): Promise<{ message: string }> {
    const lastAccess: number = Date.now();

    await this.dbDocClientInstance.send(
      new PutCommand({
        TableName: this.tableName,
        Item: {
          id: this.id,
          lastAccess
        }
      })
    );

    return {
      message: `Successfully put last access: ${lastAccess}`
    };
  }
}
