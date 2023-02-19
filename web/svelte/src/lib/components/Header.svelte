<script>
  import Button from './Button.svelte';
</script>

<header>
  <h1>t-rss-reader</h1>
  <div class="buttons">
    <Button label="Edit" />
    <Button label="Add" />
    <Button label="Log in" />
  </div>
</header>

<style>
  h1 {
    font-family: 'Roboto Slab', sans-serif;
    font-weight: 700;
    font-size: 20px;
  }

  header {
    display: flex;
    justify-content: space-between;
    height: 50px;
  }

  .buttons {
    display: flex;
    align-items: center;
    margin-right: -0.5em;
  }
</style>
