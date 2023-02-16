import {
  DeleteItemOutput,
  DynamoDBClient,
  PutItemCommandOutput,
  ScanOutput
} from '@aws-sdk/client-dynamodb';
import {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
  DeleteCommand
} from '@aws-sdk/lib-dynamodb';

export class FeedsTable {
  private tableName: string = 't-rss-reader-feeds-table';
  private dbClientInstance: DynamoDBClient;
  private dbDocClientInstance: DynamoDBDocumentClient;

  constructor() {
    this.dbClientInstance = new DynamoDBClient({});
    this.dbDocClientInstance = DynamoDBDocumentClient.from(this.dbClientInstance);
  }

  async deleteFeed(feedUrl: string): Promise<DeleteItemOutput> {
    return await this.dbDocClientInstance.send(
      new DeleteCommand({
        TableName: this.tableName,
        Key: {
          url: feedUrl
        }
      })
    );
  }

  async getFeeds(): Promise<ScanOutput> {
    return await this.dbDocClientInstance.send(new ScanCommand({ TableName: this.tableName }));
  }

  async putFeed(feedUrl: string, feedName: string): Promise<PutItemCommandOutput> {
    return await this.dbDocClientInstance.send(
      new PutCommand({
        TableName: this.tableName,
        Item: {
          url: feedUrl,
          name: feedName,
          updatedAt: Date.now()
        }
      })
    );
  }
}
