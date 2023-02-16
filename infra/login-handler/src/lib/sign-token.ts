import { getTimestamp } from './get-timestamp.js';
import jwt from 'jsonwebtoken';

export interface TokenWithExpiry {
  token: string;
  expiry: number;
}

export function signToken(): TokenWithExpiry {
  const { now, expiry } = getTimestamp();

  const token = jwt.sign(
    {
      iss: 't-rss-reader',
      sub: 'owner',
      iat: now,
      exp: expiry
    },
    process.env.T_RSS_READER_PASSWORD
  );

  return {
    token,
    expiry
  };
}
