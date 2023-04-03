import { test, vi, expect } from 'vitest';
import { LastAccessService } from '../../../src/lib/services/last-access-service';

vi.stubGlobal('fetch', () => vi.fn());

vi.mock('../../../src/lib/services/authorized-service', () => ({
  AuthorizedService: class {
    protected async headers(): Promise<HeadersInit> {
      return {};
    }
  }
}));

const api = 'a';

test('should export a constructor that accepts an api', () => {
  const LastAccessServiceInstance = new LastAccessService(api);
  expect(LastAccessServiceInstance).toBeInstanceOf(LastAccessService);
  expect(LastAccessServiceInstance.api).toBe(api);
});

test('should have a putLastAccess method', () => {
  const LastAccessServiceInstance = new LastAccessService(api);
  expect(LastAccessServiceInstance.putLastAccess).toBeTypeOf('function');
});
