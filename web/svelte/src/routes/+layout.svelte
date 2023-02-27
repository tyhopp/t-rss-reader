<script>
  import Header from '$lib/components/Header.svelte';
  import { PUBLIC_FEEDS_ORIGIN } from '$env/static/public';
  import '../app.css'
</script>

<svelte:head>
  <link rel="preconnect" href={PUBLIC_FEEDS_ORIGIN} />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="true" />
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
