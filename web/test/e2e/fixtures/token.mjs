const today = new Date();
const tomorrow = new Date(today);
tomorrow.setDate(tomorrow.getDate() + 1);

const token = {
  accessToken: 'a',
  tokenType: 'Bearer',
  expiresIn: tomorrow.getMilliseconds()
};

export { token };
