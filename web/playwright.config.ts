import { defineConfig, devices } from '@playwright/test';

const appServerUrl = 'http://localhost:8000';
const mockServerUrl = 'http://localhost:8001';

export default defineConfig({
  testDir: './test/e2e',
  timeout: 10 * 1000,
  expect: {
    timeout: 5000
  },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: process.env.CI ? 'github' : 'list',
  use: {
    actionTimeout: 0,
    baseURL: appServerUrl,
    trace: 'on-first-retry'
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] }
    }
  ],
  webServer: [
    {
      command: 'node ./test/e2e/fixtures/server.mjs',
      port: 8001
    },
    {
      command: `npm run dev`,
      port: 8000,
      env: {
        PUBLIC_FEEDS_API: `${mockServerUrl}/feeds`,
        PUBLIC_LOGIN_API: `${mockServerUrl}/login`,
        PUBLIC_ENTRIES_API: `${mockServerUrl}/entries`,
        PUBLIC_LAST_ACCESS_API: `${mockServerUrl}/last-access`
      }
    }
  ]
});
