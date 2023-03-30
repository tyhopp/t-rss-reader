<script lang="ts">
  import { onMount } from 'svelte';
  import { tokenStore } from '$lib/stores/token-store';
  import { feedsStore } from '$lib/stores/feeds-store';
  import List from '$lib/widgets/List.svelte';
  import Details from '$lib/widgets/Details.svelte';
  import UpsertFeedModal from '$lib/widgets/UpsertFeedModal.svelte';
  import BackgroundRequestEntriesWorker from '$lib/workers/background-request-entries?worker';
  import { PUBLIC_ENTRIES_API, PUBLIC_LAST_ACCESS_API } from '$env/static/public';

  onMount(async () => {
    const initialized = await tokenStore.init();

    tokenStore.subscribe((store) => {
      const { maybeValid } = store || {};

      if (initialized && !maybeValid) {
        location.assign('/login');
      }
    });

    const backgroundRequestEntriesWorker = new BackgroundRequestEntriesWorker();

    let backgroundRequestInitialized = false;

    backgroundRequestEntriesWorker.onmessage = (event: MessageEvent) => {
      if (event?.data?.startsWith('https')) {
        feedsStore.update((prevFeeds) => {
          const unsortedNextFeeds = prevFeeds.map((prevFeed) => {
            if (event.data === prevFeed.url) {
              prevFeed.hasNew = true;
            }
            return prevFeed;
          });

          const sortedNextFeeds = unsortedNextFeeds.sort((a, b) => {
            if (a.hasNew && b.hasNew) {
              return a.name.localeCompare(b.name);
            }

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
      if (!backgroundRequestInitialized && feeds.length) {
        const urls = feeds.map((feed) => feed.url);

        backgroundRequestEntriesWorker.postMessage({
          entriesApi: PUBLIC_ENTRIES_API,
          lastAccessApi: PUBLIC_LAST_ACCESS_API,
          urls
        });

        backgroundRequestInitialized = true;
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
