import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
  DeleteCommand
} from '@aws-sdk/lib-dynamodb';

interface FeedItem {
  url: string;
  name: string;
  createdAt: number;
}

type FeedItems = Array<FeedItem>;

export class FeedsTable {
  private tableName: string = 't-rss-reader-feeds-table';
  private dbClientInstance: DynamoDBClient;
  private dbDocClientInstance: DynamoDBDocumentClient;

  constructor() {
    this.dbClientInstance = new DynamoDBClient({});
    this.dbDocClientInstance = DynamoDBDocumentClient.from(this.dbClientInstance);
  }

  async deleteFeed(feedUrl: string): Promise<{ message: string }> {
    await this.dbDocClientInstance.send(
      new DeleteCommand({
        TableName: this.tableName,
        Key: {
          url: feedUrl
        }
      })
    );

    return { message: `Successfully deleted ${feedUrl}` };
  }

  async getFeeds(): Promise<FeedItems> {
    const response = await this.dbDocClientInstance.send(
      new ScanCommand({ TableName: this.tableName })
    );
    return response?.Items as FeedItems;
  }

  async putFeed(feedUrl: string, feedName: string): Promise<{ message: string; feed: FeedItem }> {
    const item: FeedItem = {
      url: feedUrl,
      name: feedName,
      createdAt: Date.now()
    };

    await this.dbDocClientInstance.send(
      new PutCommand({
        TableName: this.tableName,
        Item: item
      })
    );

    return {
      message: `Successfully put ${item.url}`,
      feed: item
    };
  }
}
