import * as dayjs from 'dayjs';

export interface TimeStamps {
  now: number;
  expiry: number;
}

export function getTimestamp(): TimeStamps {
  const now = dayjs();

  /**
   * Disclamer - A long-lived access token is sent. Reasons:
   *
   * - Data stored for this app is not particularly sensitive
   * - Straightforward to revoke access tokens by changing the password
   * - HTTP-only cookies are not convenient for localhost development and non-web based clients
   * - Prefer to keep infra implementation as simple as possible
   *
   * Of course, make your own judgement based on your own requirements. This is acceptable for me for this use case.
   */
  const expiry = now.add(1, 'month');

  return {
    now: now.valueOf(),
    expiry: expiry.valueOf()
  };
}
