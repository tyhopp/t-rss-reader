<script lang="ts">
  import List from '../components/List.svelte';
  import Details from '../components/Details.svelte';
  import { feedsStore } from '../stores/feeds-store';
  import { onMount } from 'svelte';

  onMount(() => {
    feedsStore.init();
  });
</script>

<section>
  <List />
  <Details />
</section>

<style>
  section {
    display: flex;
    flex: 1;
  }
</style>
