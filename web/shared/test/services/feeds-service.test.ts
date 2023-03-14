import { test, vi, expect } from 'vitest';
import { FeedsService } from '../../src/services/feeds-service';

const api = 'api';
const url = 'url';
const name = 'name';

const FeedsServiceInstance = new FeedsService(api);

const deleteFeedSpy = vi.spyOn(FeedsServiceInstance, 'deleteFeed');
const putFeedSpy = vi.spyOn(FeedsServiceInstance, 'putFeed');

vi.stubGlobal('fetch', () => vi.fn());

vi.mock('../../src/utils/get-access-token', () => ({
  getAccessToken: vi.fn()
}));

test('should export a constructor that accepts an api', () => {
  const FeedsServiceInstance = new FeedsService(api);
  expect(FeedsServiceInstance).toBeInstanceOf(FeedsService);
  expect(FeedsServiceInstance.api).toBe(api);
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
