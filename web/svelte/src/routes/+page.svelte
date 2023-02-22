<script lang="ts">
  import { onMount } from 'svelte';
  import { tokenStore } from '$lib/stores/token-store';
  import ListDetails from '$lib/widgets/ListDetails.svelte';
  import AddFeedModal from '$lib/widgets/AddFeedModal.svelte';

  onMount(() => {
    tokenStore.subscribe(({ maybeValid }) => {
      if (!maybeValid) {
        location.assign('/login');
      }
    });
  });
</script>

<ListDetails />
<AddFeedModal />
