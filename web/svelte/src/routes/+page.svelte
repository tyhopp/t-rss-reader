<script>
  import Header from '$lib/components/Header.svelte';
  import LoginForm from '$lib/widgets/LoginForm.svelte';
  import ListDetails from '$lib/widgets/ListDetails.svelte';
  import { FeedsService } from '$lib/services/feeds-service';

  let FeedsServiceInstance = new FeedsService();
</script>

<Header />

{#await FeedsServiceInstance.getFeeds()}
  <div>Loading...</div>
{:then response}
  {#if response?.message === 'Unauthorized'}
    <LoginForm />
  {:else if response?.feeds}
    <ListDetails feeds={response.feeds} />
  {/if}
{:catch error}
  There was an error
{/await}

<style>
  div {
    max-width: 300px;
    margin: 0 auto;
    text-align: center;
  }
</style>
