<script lang="ts">
  import { onMount } from 'svelte';
  import DetailsItem from '../components/DetailsItem.svelte';
  import Loading from '../components/Loading.svelte';
  import Button from '../components/Button.svelte';
  import FeedEntriesService from '../services/feed-entries-service';
  import { feedsStore } from '../stores/feeds-store';
  import { selectedFeedStore } from '../stores/selected-feed-store';
  import { parseRssXml } from '../utils/parse-rss-xml';
  import { extractFeedEntries } from '../utils/extract-feed-entries';
  import { getRandomIntInclusive } from '../utils/get-random-inclusive';
  import type { RssFeedEntries } from '../types';

  let loading: boolean = false;
  let selected: boolean = false;
  let entriesFailed: boolean = false;
  let entries: RssFeedEntries = [];

  onMount(() => {
    selectedFeedStore.subscribe((selectedFeed) => {
      if (!selectedFeed) {
        loading = false;
        selected = false;
        entriesFailed = false;
        entries = [];
        return;
      }

      selected = true;
      loading = true;

      FeedEntriesService.getEntries(selectedFeed)
        .then((xml) => {
          if (!xml) {
            entriesFailed = true;
            return;
          }

          const doc = parseRssXml(selectedFeed, xml);

          if (!doc) {
            entriesFailed = true;
            return;
          }

          entries = extractFeedEntries(doc);
          entriesFailed = !entries.length;
        })
        .catch((error) => {
          entriesFailed = true;
          console.error(error);
        })
        .finally(() => {
          loading = false;
        });
    });
  });

  function onSelectRandom() {
    const randomInt = getRandomIntInclusive(0, $feedsStore.length - 1);
    const { url } = $feedsStore[randomInt];
    selectedFeedStore.set(url);
  }
</script>

<div>
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
