<script lang="ts">
  import { onMount } from 'svelte';
  import { tokenStore } from '$lib/stores/token-store';
  import ListDetails from '$lib/widgets/ListDetails.svelte';
  import UpsertFeedModal from '$lib/widgets/UpsertFeedModal.svelte';

  onMount(() => {
    tokenStore.subscribe(({ maybeValid }) => {
      if (!maybeValid) {
        location.assign('/login');
      }
    });
  });
</script>

<ListDetails />
<UpsertFeedModal />
