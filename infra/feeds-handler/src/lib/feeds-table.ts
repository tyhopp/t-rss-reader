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
  updatedAt: number;
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

  async deleteFeed(feedUrl: string): Promise<string> {
    await this.dbDocClientInstance.send(
      new DeleteCommand({
        TableName: this.tableName,
        Key: {
          url: feedUrl
        }
      })
    );

    return `Successfully deleted ${feedUrl}`;
  }

  async getFeeds(): Promise<FeedItems> {
    const response = await this.dbDocClientInstance.send(
      new ScanCommand({ TableName: this.tableName })
    );
    return response?.Items as FeedItems;
  }

  async putFeed(feedUrl: string, feedName: string): Promise<FeedItem> {
    const feedItem: FeedItem = {
      url: feedUrl,
      name: feedName,
      createdAt: Date.now(),
      updatedAt: Date.now()
    };

    await this.dbDocClientInstance.send(
      new PutCommand({
        TableName: this.tableName,
        Item: feedItem
      })
    );

    return feedItem;
  }
}
