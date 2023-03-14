import server from 'pure-http';

const accessToken = 'a';
const today = new Date();
const tomorrow = new Date(today);
tomorrow.setDate(tomorrow.getDate() + 1);

let feeds = [];
let lastAccess = Date.now();

const entries = new Map([
  [
    'https://feed-a.com/rss.xml',
    {
      url: 'https://entry-a.com',
      title: 'entry-a',
      published: Date.now().toString()
    },
    {
      url: 'https://entry-b.com',
      title: 'entry-b',
      published: Date.now().toString()
    }
  ],
  [
    'https://feed-b.com/rss.xml',
    {
      url: 'https://entry-c.com',
      title: 'entry-c',
      published: Date.now().toString()
    },
    {
      url: 'https://entry-d.com',
      title: 'entry-d',
      published: Date.now().toString()
    }
  ]
]);

const app = server();

app.get('/login', (_, res) => {
  res.send(
    JSON.stringify({
      accessToken,
      tokenType: 'Bearer',
      expiresIn: tomorrow.getMilliseconds()
    })
  );
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
