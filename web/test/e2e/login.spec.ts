import { test, expect } from '@playwright/test';

test('fails with incorrect password', async ({ page }) => {
  await page.goto('/login');

  await expect(page.locator('button[type=submit]')).toBeDisabled();

  await page.locator('input[name=password]').type('incorrect-password');
  await page.locator('button[type=submit]').click();

  await expect(page.locator('[data-result=failure]')).toBeVisible();
});

test('succeeds with correct password', async ({ page }) => {
  await page.goto('/login');

  await expect(page.locator('button[type=submit]')).toBeDisabled();

  await page.locator('input[name=password]').type('password');
  await page.locator('button[type=submit]').click();

  await expect(page.locator('[data-result=success]')).toBeVisible();
});
