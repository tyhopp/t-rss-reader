const defaultConfig = require('../../.prettierrc.cjs');

module.exports = {
  ...defaultConfig,
  plugins: ['prettier-plugin-svelte'],
  pluginSearchDirs: ['.'],
  overrides: [{ files: '*.svelte', options: { parser: 'svelte' } }]
};
