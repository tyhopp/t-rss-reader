<script lang="ts">
  import { onMount } from 'svelte';
  import { tokenStore } from '$lib/stores/token-store';
  import { feedsStore } from '$lib/stores/feeds-store';
  import List from '$lib/widgets/List.svelte';
  import Details from '$lib/widgets/Details.svelte';
  import UpsertFeedModal from '$lib/widgets/UpsertFeedModal.svelte';
  import AllEntriesWorker from '$lib/workers/all-entries-worker?worker';

  onMount(async () => {
    const initialized = await tokenStore.init();

    tokenStore.subscribe((store) => {
      const { maybeValid } = store || {};

      if (initialized && !maybeValid) {
        location.assign('/login');
      }
    });

    feedsStore.subscribe((feeds) => {
      if (feeds.length) {
        const urls = feeds.map((feed) => feed.url);
        const allEntriesWorker = new AllEntriesWorker();
        allEntriesWorker.postMessage(urls);
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
