<script lang="ts">
  import List from '../components/List.svelte';
  import Details from '../components/Details.svelte';
  import type { Feed } from '../types';

  export let feeds: Array<Feed>;
</script>

<section>
  <List {feeds} />
  <Details />
</section>

<style>
  section {
    display: flex;
    flex: 1;
  }
</style>
