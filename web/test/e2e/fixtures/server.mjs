import server from 'pure-http';
import { entries } from './entries.mjs';
import { token } from './token.mjs';

let feeds = [];
let lastAccess = Date.now();

const app = server();

app.use((_, res, next) => {
  res.header('Access-Control-Allow-Origin', 'http://localhost:8000');
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length');
  next();
});

app.options('/*', (_, res) => {
  res.send(200);
});

app.post('/login', (req, res) => {
  if (req.header('authorization') === 'password') {
    res.send(JSON.stringify(token));
  } else {
    res.send(JSON.stringify({ message: 'Failed to authorize' }));
  }
});

app.put('/last-access', (_, res) => {
  lastAccess = Date.now();
  res.send(
    JSON.stringify({
      message: `Successfully put last access: ${lastAccess}`
    })
  );
});

app.delete('/feeds', (req, res) => {
  feeds = feeds.filter((feed) => feed?.url !== req.body.url);
  res.send(
    JSON.stringify({
      message: `Successfully deleted ${feedUrl}`
    })
  );
});

app.get('/feeds', (_, res) => {
  res.send(JSON.stringify(feeds));
});

app.get('/put', (req, res) => {
  const feed = {
    url: req.body.url,
    name: req.body.name,
    createdAt: Date.now()
  };

  feeds.push(feed);

  res.send(
    JSON.stringify({
      message: `Successfully put ${req.body.url}`,
      feed
    })
  );
});

app.get('/entries', (req, res) => {
  if (entries.has(req.params.url)) {
    res.send(JSON.stringify(entries.get(req.params.url)));
  } else {
    res.send(JSON.stringify({ message: `Failed to fetch feed ${req.params.url}` }), false, 400);
  }
});

app.listen(8001);

console.info('Mock server listening on http://localhost:8001');
