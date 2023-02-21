<script lang="ts">
  import { onMount } from 'svelte';
  import { tokenStore } from '$lib/stores/token-store';
  import { FeedsService } from '$lib/services/feeds-service';
  import ListDetails from '$lib/widgets/ListDetails.svelte';
  import AddFeedModal from '$lib/widgets/AddFeedModal.svelte';

  let FeedsServiceInstance: FeedsService;

  onMount(() => {
    tokenStore.subscribe(({ maybeValid }) => {
      if (maybeValid) {
        FeedsServiceInstance = new FeedsService();
      } else {
        location.assign('/login');
      }
    });
  });
</script>

{#if FeedsServiceInstance instanceof FeedsService}
  {#await FeedsServiceInstance.getFeeds()}
    <div>Loading...</div>
  {:then response}
    {#if 'message' in response && response.message === 'Unauthorized'}
      {location.assign('/login')}
    {:else if 'feeds' in response && Array.isArray(response.feeds)}
      <ListDetails feeds={response.feeds} />
    {/if}
  {:catch error}
    There was an error: {error.message}
  {/await}
{/if}

<AddFeedModal />

<style>
  div {
    max-width: 300px;
    margin: 0 auto;
    text-align: center;
  }
</style>
