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

export { entries };
