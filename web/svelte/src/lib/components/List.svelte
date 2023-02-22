<script lang="ts">
  import ListItem from './ListItem.svelte';
  import Button from './Button.svelte';
  import { modalStore } from '../stores/modal-store';
  import type { Feeds } from '../types';

  export let feeds: Feeds;
</script>

<ul>
  {#each feeds as { name, url }}
    <ListItem {name} {url} />
  {/each}
  {#if feeds.length === 0}
    <div>
      <p>No feeds yet</p>
      <Button label="Add" on:click={() => modalStore.toggle()} />
    </div>
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
