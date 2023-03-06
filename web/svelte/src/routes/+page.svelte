<script lang="ts">
  import { onMount } from 'svelte';
  import { tokenStore } from '$lib/stores/token-store';
  import { feedsStore } from '$lib/stores/feeds-store';
  import List from '$lib/widgets/List.svelte';
  import Details from '$lib/widgets/Details.svelte';
  import UpsertFeedModal from '$lib/widgets/UpsertFeedModal.svelte';
  import AllEntriesWorker from '$lib/workers/all-entries-worker?worker';
  import { PUBLIC_ENTRIES_API, PUBLIC_LAST_ACCESS_API } from '$env/static/public';

  onMount(async () => {
    const initialized = await tokenStore.init();

    tokenStore.subscribe((store) => {
      const { maybeValid } = store || {};

      if (initialized && !maybeValid) {
        location.assign('/login');
      }
    });

    const allEntriesWorker = new AllEntriesWorker();

    let allEntriesWorkerFinished = false;

    allEntriesWorker.onmessage = (event: MessageEvent) => {
      if (event?.data === 'finished') {
        allEntriesWorkerFinished = true;
      }

      if (event?.data?.size) {
        feedsStore.update((prevFeeds) => {
          const unsortedNextFeeds = prevFeeds.map((prevFeed) => {
            prevFeed.hasNew = event.data.has(prevFeed.url);
            return prevFeed;
          });

          const sortedNextFeeds = unsortedNextFeeds.sort((a, b) => {
            if (a.hasNew) {
              return -1;
            }

            if (b.hasNew) {
              return 1;
            }

            return 0;
          });

          return sortedNextFeeds;
        });
      }
    };

    feedsStore.subscribe((feeds) => {
      if (!allEntriesWorkerFinished && feeds.length) {
        const urls = feeds.map((feed) => feed.url);

        allEntriesWorker.postMessage({
          entriesApi: PUBLIC_ENTRIES_API,
          lastAccessApi: PUBLIC_LAST_ACCESS_API,
          urls
        });
      }
    });
  });
</script>

<section>
  <List />
  <Details />
</section>

<UpsertFeedModal />

<style>
  section {
    display: flex;
    flex: 1;
  }
</style>
