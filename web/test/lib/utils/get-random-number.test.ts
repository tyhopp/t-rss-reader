import { test, expect } from 'vitest';
import { getRandomNumber } from '../../../src/lib/utils/get-random-number';

test('should return 0 if min and max is 0', () => {
  const number = getRandomNumber(0, 0);
  expect(number).toEqual(0);
});

test('should return a number between 0 and 1 inclusively', () => {
  const number = getRandomNumber(0, 1);
  expect(number).toBeGreaterThanOrEqual(0);
  expect(number).toBeLessThanOrEqual(1);
});
