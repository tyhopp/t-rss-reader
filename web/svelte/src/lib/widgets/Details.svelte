<script lang="ts">
  import { onMount } from 'svelte';
  import DetailsItem from '../components/DetailsItem.svelte';
  import { FeedEntriesService } from '../services/feed-entries-service';
  import { selectedFeedStore } from '../stores/selected-feed-store';
  import { parseRssXml } from '../utils/parse-rss-xml';
  import { extractFeedEntries } from '../utils/extract-feed-entries';
  import type { RssFeedEntries } from '../types';

  let entries: RssFeedEntries = [];

  onMount(() => {
    selectedFeedStore.subscribe((selectedFeed) => {
      if (!selectedFeed) {
        return;
      }

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
        });
    });
  });
</script>

<ul>
  {#each entries as entry}
    <DetailsItem {entry} />
  {/each}
</ul>

<style>
  ul {
    display: none;
  }

  @media (min-width: 600px) {
    ul {
      flex: 1;
      display: flex;
      flex-direction: column;
      overflow-y: auto;
      padding: 0;
      margin: 0;
      border-top: 1px dashed var(--line);
      border-right: 1px dashed var(--line);
    }
  }
</style>
