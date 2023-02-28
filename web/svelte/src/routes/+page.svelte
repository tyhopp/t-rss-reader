<script lang="ts">
  import { onMount } from 'svelte';
  import { tokenStore } from '$lib/stores/token-store';
  import List from '$lib/widgets/List.svelte';
  import Details from '$lib/widgets/Details.svelte';
  import UpsertFeedModal from '$lib/widgets/UpsertFeedModal.svelte';

  onMount(() => {
    tokenStore.subscribe(({ maybeValid }) => {
      if (!maybeValid) {
        location.assign('/login');
      }
    });
  });
</script>

<section>
  <List />
  <Details />
</section>

<UpsertFeedModal />

<style>
  section {
    display: flex;
    flex: 1;
  }
</style>
