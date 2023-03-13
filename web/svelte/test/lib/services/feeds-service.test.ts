import { test, vi, expect } from 'vitest';
import FeedsServiceInstance, { FeedsService } from '../../../src/lib/services/feeds-service';

vi.stubGlobal('fetch', () => vi.fn());

const url = 'a-url';
const name = 'a-name';

const deleteFeedSpy = vi.spyOn(FeedsServiceInstance, 'deleteFeed');
const putFeedSpy = vi.spyOn(FeedsServiceInstance, 'putFeed');

vi.mock('../../../src/lib/utils/get-access-token', () => ({
  getAccessToken: vi.fn()
}));

test('should have a default export of a constructed instance', () => {
  expect(FeedsServiceInstance).toBeInstanceOf(FeedsService);
});

test('should have a deleteFeed method', () => {
  expect(FeedsServiceInstance.deleteFeed).toBeTypeOf('function');
});

test('should have a getFeeds method', () => {
  expect(FeedsServiceInstance.getFeeds).toBeTypeOf('function');
});

test('should have a putFeed method', () => {
  expect(FeedsServiceInstance.putFeed).toBeTypeOf('function');
});

test('should call the deleteFeed method with a url', async () => {
  await FeedsServiceInstance.deleteFeed(url);
  expect(deleteFeedSpy).toHaveBeenCalledWith(url);
});

test('should call the putFeed method with a url and name', async () => {
  await FeedsServiceInstance.putFeed(url, name);
  expect(putFeedSpy).toHaveBeenCalledWith(url, name);
});
