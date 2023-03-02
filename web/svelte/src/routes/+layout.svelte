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
</svelte:head>

<Header />
<slot />
