<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="true">
  <link href="https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@400;500&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@700&text=t-rss-reader&display=swap" rel="stylesheet">
  <style>
    :root {
      --text: #363535;
      --line: #bebdbd;
      --background: #fffbf4;
      --accent: #3c8ec9;
    }

    html {
      font-family: 'Roboto Slab', sans-serif;
      text: var(--text);
      background-color: var(--background)
    }
  </style>
</svelte:head>

<main>
  <slot />
</main>

<style>
  main {
    display: flex;
    flex-direction: column;
    max-width: 1000px;
    margin: 0 auto;
  }
</style>