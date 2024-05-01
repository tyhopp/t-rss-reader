<script>
  import Header from '$lib/components/Header.svelte';
  import { PUBLIC_FEEDS_API, PUBLIC_ENTRIES_API } from '$env/static/public';
  import '../app.css';

  const feedsOrigin = new URL(PUBLIC_FEEDS_API).origin;
  const entriesOrigin = new URL(PUBLIC_ENTRIES_API).origin;
</script>

<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="true" />
  <link rel="preconnect" href={feedsOrigin} />
  <link rel="preconnect" href={entriesOrigin} />
  <link
    href="https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@500&display=swap"
    rel="stylesheet"
  />
  <link
    href="https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@700&text=t-rss-reader&display=swap"
    rel="stylesheet"
  />
  <link rel="apple-touch-icon-precomposed" sizes="180x180" href="favicon-180.jpg" />
  <link rel="apple-touch-icon" sizes="180x180" href="favicon-180.jpg" />
  <link rel="icon" type="image/jpeg" sizes="512x512" href="favicon-512.jpg" />
  <link rel="icon" type="image/jpeg" sizes="48x48" href="favicon-48.jpg" />
  <link rel="icon" type="image/jpeg" sizes="32x32" href="favicon-32.jpg" />
  <link rel="icon" type="image/jpeg" sizes="16x16" href="favicon-16.jpg" />
  <link rel="icon" href="favicon.ico" />
  <link rel="manifest" href="manifest.json">
  <meta property="og:type" content="website" />
  <meta property="og:image" content="open-graph-card.jpg" />
  <meta property="og:image:width" content="1200" />
  <meta property="og:image:height" content="630" />
  <meta name="twitter:card" content="summary" />
</svelte:head>

<Header />
<slot />
