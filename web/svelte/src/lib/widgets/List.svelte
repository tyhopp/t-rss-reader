<script lang="ts">
  import { onMount } from 'svelte';
  import ListItem from '../components/ListItem.svelte';
  import Button from '../components/Button.svelte';
  import Loading from '../components/Loading.svelte';
  import { modalStore } from '../stores/modal-store';
  import { feedsStore } from '../stores/feeds-store';
  import { selectedFeedStore } from '../stores/selected-feed-store';
  import { Result } from '../types';

  let initialized: Result = Result.none;
  let disabled: boolean = false;
  let attempts: number = 0;

  onMount(async () => {
    initialized = await feedsStore.init();
  });

  async function retry() {
    initialized = await feedsStore.init();

    if (initialized === Result.failure) {
      attempts++;
    }
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<ul on:click>
  {#if initialized === Result.none}
    <div>
      <Loading --margin="4em" />
    </div>
  {:else if initialized === Result.failure}
    <div>
      <p>Failed to get feeds</p>
      <p>Attempts: {attempts}</p>
      <Button label="Retry" on:click={async () => retry()} {disabled} />
    </div>
  {:else if initialized === Result.success && $feedsStore?.length === 0}
    <div>
      <p>No feeds yet</p>
      <Button label="Add" on:click={() => modalStore.toggle()} />
    </div>
  {:else}
    {#each $feedsStore as { name, url }}
      <ListItem {name} {url} selected={url === $selectedFeedStore} />
    {/each}
  {/if}
</ul>

<style>
  ul {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-width: 300px;
    overflow-y: auto;
    padding: 0;
    margin: 0;
    border-top: 1px dashed var(--line);
    border-left: 1px dashed var(--line);
    border-right: 1px dashed var(--line);
  }

  @media (min-width: 600px) {
    ul {
      max-width: 350px;
    }
  }

  div {
    margin: 2em 1em;
    text-align: center;
  }
</style>
