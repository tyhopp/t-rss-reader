<svelte:head>
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
      background-color: var(--background);
    }
  </style>
</svelte:head>

<slot />

<style>
  :global(body) {
    margin: 0;
    height: 100vh;
    width: 100vw;
    overflow: hidden;
  }

  :global(main#sveltekit-body) {
    display: flex;
    flex-direction: column;
    max-width: 1000px;
    height: 100%;
    margin: 0 auto;
  }

  :global(main#sveltekit-body > *) {
    min-width: 0;
    min-height: 0;
  }
</style>
