import jwt from 'jsonwebtoken';

export function verifyToken(authorization: string): boolean {
  try {
    jwt.verify(authorization, process.env.T_RSS_READER_PASSWORD);
    return true;
  } catch (_) {
    return false;
  }
}
