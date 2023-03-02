<script lang="ts">
  import { onMount } from 'svelte';
  import DetailsItem from '../components/DetailsItem.svelte';
  import Loading from '../components/Loading.svelte';
  import Button from '../components/Button.svelte';
  import EntriesService from '../services/entries-service';
  import { feedsStore } from '../stores/feeds-store';
  import { selectedFeedStore } from '../stores/selected-feed-store';
  import { getRandomNumber } from '../utils/get-random-number';
  import type { RssFeedEntries } from '../types';

  let loading: boolean = false;
  let selected: boolean = false;
  let entriesFailed: boolean = false;
  let entries: RssFeedEntries = [];

  function reset() {
    loading = false;
    selected = false;
    entriesFailed = false;
    entries = [];
  }

  onMount(() => {
    selectedFeedStore.subscribe((selectedFeed) => {
      if (!selectedFeed) {
        reset();
        return;
      }

      selected = true;
      loading = true;

      EntriesService.getEntries(selectedFeed.url)
        .then((response) => response.json())
        .then((nextEntries) => {
          if (!nextEntries) {
            entriesFailed = true;
            return;
          }

          entries = nextEntries;
        })
        .catch(() => {
          entriesFailed = true;
        })
        .finally(() => {
          loading = false;
        });
    });
  });

  function onSelectRandom() {
    const randomInt = getRandomNumber(0, $feedsStore.length - 1);
    const newSelectedFeed = $feedsStore[randomInt];
    selectedFeedStore.set(newSelectedFeed);
  }
</script>

<div data-selected={selected}>
  {#if loading}
    <Loading />
  {:else if !selected && !entriesFailed && $feedsStore.length}
    <section>
      <p>Select a feed to view entries</p>
      <Button label="Select random" on:click={onSelectRandom} />
    </section>
  {:else if selected && entriesFailed}
    <section>
      <p>Failed to get entries</p>
    </section>
  {:else if selected && entries.length}
    <ul>
      {#each entries as entry}
        <DetailsItem {entry} />
      {/each}
    </ul>
  {/if}
</div>

<style>
  div {
    display: none;
  }

  div[data-selected='true'] {
    flex: 1;
    display: flex;
  }

  @media (min-width: 600px) {
    div {
      flex: 1;
      display: flex;
      flex-direction: column;
      border-top: 1px dashed var(--line);
      border-right: 1px dashed var(--line);
    }
  }

  section {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: 2em auto;
  }

  ul {
    padding: 0;
    margin: 0;
    overflow-y: auto;
  }
</style>
