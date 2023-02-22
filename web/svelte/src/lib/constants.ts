import * as env from '$env/static/public';

export const FEEDS_API = [env.PUBLIC_FEEDS_ORIGIN, env.PUBLIC_FEEDS_STAGE, env.PUBLIC_FEEDS_PATH]
  .filter(Boolean)
  .join('/');

export const LOGIN_API = [env.PUBLIC_LOGIN_ORIGIN, env.PUBLIC_LOGIN_STAGE, env.PUBLIC_LOGIN_PATH]
  .filter(Boolean)
  .join('/');

export const LOCAL_STORAGE_ACCESS_TOKEN_KEY = 't-rss-reader-access-token';

export const LOCAL_STORAGE_FEEDS_CACHE_KEY = 't-rss-reader-feeds';
