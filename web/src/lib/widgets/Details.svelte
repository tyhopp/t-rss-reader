<script lang="ts">
  import { onMount } from 'svelte';
  import DetailsItem from '../components/DetailsItem.svelte';
  import Loading from '../components/Loading.svelte';
  import Button from '../components/Button.svelte';
  import { EntriesService } from '../services/entries-service';
  import { feedsStore } from '../stores/feeds-store';
  import { selectedFeedStore } from '../stores/selected-feed-store';
  import { getRandomNumber } from '../utils/get-random-number';
  import { PUBLIC_ENTRIES_API } from '$env/static/public';
  import { handleJumpKeyboardEvents } from '../utils/handle-jump-keyboard-events';
  import type { RssFeedEntries } from '../types';

  let loading: boolean = false;
  let hasSelection: boolean = false;
  let entriesFailed: boolean = false;
  let entries: RssFeedEntries = [];
  let prevSelected: string | undefined;
  let abortController: AbortController | undefined;

  function reset(): void {
    loading = false;
    hasSelection = false;
    entriesFailed = false;
    entries = [];
    prevSelected = undefined;
    abortController = undefined;
  }

  onMount(() => {
    selectedFeedStore.subscribe((nextSelected) => {
      if (!nextSelected) {
        reset();
        return;
      }

      if (prevSelected !== nextSelected.url && abortController) {
        abortController.abort();
      }

      loading = true;
      hasSelection = true;
      entriesFailed = false;
      entries = [];

      const entriesService = new EntriesService(PUBLIC_ENTRIES_API);
      abortController = new AbortController();

      entriesService
        .getEntries({ url: nextSelected.url, abortController })
        .then((response) => response.json())
        .then((nextEntries) => {
          if (!nextEntries) {
            entriesFailed = true;
            return;
          }

          entries = nextEntries;
          loading = false;
          abortController = undefined;
        })
        .catch((error) => {
          if (error.name !== 'AbortError') {
            entriesFailed = true;
            loading = false;
            abortController = undefined;
          }
        })
        .finally(() => {
          prevSelected = nextSelected.url;
        });
    });
  });

  function onSelectRandom() {
    const randomInt = getRandomNumber(0, $feedsStore.length - 1);
    const newSelectedFeed = $feedsStore[randomInt];
    selectedFeedStore.set(newSelectedFeed);
  }

  function onKeyDown(event: KeyboardEvent) {
    if (entries.length) {
      handleJumpKeyboardEvents(event, '[data-elem=details-item] a');
    }
  }
</script>

<div data-has-selection={hasSelection}>
  {#if loading}
    <Loading />
  {:else if !hasSelection && !entriesFailed && $feedsStore.length}
    <section>
      <p>Select a feed to view entries</p>
      <Button label="Select random" on:click={onSelectRandom} />
    </section>
  {:else if hasSelection && entriesFailed}
    <section>
      <p>Failed to get entries</p>
    </section>
  {:else if hasSelection && entries.length}
    <ul on:keydown={onKeyDown}>
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

  div[data-has-selection='true'] {
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
    flex: 1;
    padding: 0 0 1em 0;
    margin: 0;
    overflow-y: auto;
  }
</style>
