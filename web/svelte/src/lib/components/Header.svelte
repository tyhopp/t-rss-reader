<script>
  import Button from './Button.svelte';
</script>

<header>
  <h1>t-rss-reader</h1>
  <div class="buttons">
    <Button label="Edit" />
    <Button label="Add" />
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
    padding: 0 1em;
  }

  .buttons {
    display: flex;
    align-items: center;
  }
</style>
