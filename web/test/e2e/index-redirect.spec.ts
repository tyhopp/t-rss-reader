import { test, expect } from '@playwright/test';

test('redirects to login page when not authenticated', async ({ page }) => {
  await page.goto('/');

  await expect(page).toHaveURL('/login');
});
