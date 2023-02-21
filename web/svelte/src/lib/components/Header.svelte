<script lang="ts">
  import { onMount } from 'svelte';
  import { tokenStore } from '../stores/token-store';
  import Button from './Button.svelte';

  let disabled: boolean = true;

  onMount(() => {
    tokenStore.subscribe(({ maybeValid }) => {
      if (maybeValid) {
        disabled = false;
      }
    });
  });
</script>

<header>
  <h1>t-rss-reader</h1>
  <div class="buttons">
    <Button label="Edit" {disabled} />
    <Button label="Add" {disabled} />
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
