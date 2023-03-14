import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vitest/config';

export default defineConfig({
  server: {
    port: 8000
  },
  preview: {
    port: 8000
  },
  plugins: [sveltekit()],
  test: {
    include: ['test/**/*.{test,spec}.ts'],
    watch: false
  }
});
