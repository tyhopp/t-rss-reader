<script lang="ts">
  import { onMount } from 'svelte';
  import DetailsItem from '../components/DetailsItem.svelte';
  import Loading from '../components/Loading.svelte';
  import { FeedEntriesService } from '../services/feed-entries-service';
  import { selectedFeedStore } from '../stores/selected-feed-store';
  import { parseRssXml } from '../utils/parse-rss-xml';
  import { extractFeedEntries } from '../utils/extract-feed-entries';
  import type { RssFeedEntries } from '../types';

  let loading: boolean = false;
  let entries: RssFeedEntries = [];

  onMount(() => {
    selectedFeedStore.subscribe((selectedFeed) => {
      if (!selectedFeed) {
        return;
      }

      loading = true;

      const feedEntriesServiceInstance = new FeedEntriesService();

      feedEntriesServiceInstance
        .getEntries(selectedFeed)
        .then((xml) => {
          if (!xml) {
            return;
          }

          const doc = parseRssXml(selectedFeed, xml);

          if (!doc) {
            return;
          }

          entries = extractFeedEntries(doc);
        })
        .catch((error) => {
          console.error(error);
        })
        .finally(() => {
          loading = false;
        });
    });
  });
</script>

<div>
  {#if loading}
    <Loading />
  {:else}
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

    ul {
      padding: 0;
      margin: 0;
      overflow-y: auto;
    }
  }
</style>
