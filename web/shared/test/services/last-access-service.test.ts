import { test, vi, expect } from 'vitest';
import { LastAccessService } from '../../src/services/last-access-service';

const api = 'a';

vi.stubGlobal('fetch', () => vi.fn());

vi.mock('../../src/utils/get-access-token', () => ({
  getAccessToken: vi.fn()
}));

test('should export a constructor that accepts an api', () => {
  const LastAccessServiceInstance = new LastAccessService(api);
  expect(LastAccessServiceInstance).toBeInstanceOf(LastAccessService);
  expect(LastAccessServiceInstance.api).toBe(api);
});

test('should have a putLastAccess method', () => {
  const LastAccessServiceInstance = new LastAccessService(api);
  expect(LastAccessServiceInstance.putLastAccess).toBeTypeOf('function');
});
