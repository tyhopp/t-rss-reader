<script lang="ts">
  import { onMount } from 'svelte';
  import ListItem from '../components/ListItem.svelte';
  import Button from '../components/Button.svelte';
  import { modalStore } from '../stores/modal-store';
  import { feedsStore } from '../stores/feeds-store';
  import { selectedFeedStore } from '../stores/selected-feed-store';

  let cacheLoaded: boolean;

  onMount(() => {
    cacheLoaded = feedsStore.loadCache();
    feedsStore.revalidate();
  });
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<ul on:click>
  {#if cacheLoaded && $feedsStore?.length === 0}
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
