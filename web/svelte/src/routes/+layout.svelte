<svelte:head>
  <link
    rel="preload"
    href="okomito-regular.woff2"
    as="font"
    type="font/woff2"
    crossorigin="true"
  />
  <link
    rel="preload"
    href="okomito-medium.woff2"
    as="font"
    type="font/woff2"
    crossorigin="true"
  />
  <link
    rel="preload"
    href="okomito-bold.woff2"
    as="font"
    type="font/woff2"
    crossorigin="true"
  />
  <style>
    :root {
      --text: #363535;
      --line: #bebdbd;
      --background: #fffbf4;
      --accent: #3c8ec9;
    }

    @font-face {
      font-family: 'Okomito Regular';
      src: url('/okomito-regular.woff2') format('woff2');
      font-weight: 400;
      font-display: swap;
    }

    @font-face {
      font-family: 'Okomito Medium';
      src: url('/okomito-medium.woff2') format('woff2');
      font-weight: 600;
      font-display: swap;
    }

    @font-face {
      font-family: 'Okomito Bold';
      src: url('/okomito-bold.woff2') format('woff2');
      font-weight: 800;
      font-display: swap;
    }

    html {
      font-family: 'Okomito Regular', sans-serif;
      text: var(--text);
      background-color: var(--background)
    }

    h1, h2, h3, h4 {
      font-family: 'Okomito Bold', sans-serif;
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