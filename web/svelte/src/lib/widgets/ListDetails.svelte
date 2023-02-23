<script lang="ts">
  import List from './List.svelte';
  import Details from './Details.svelte';
  import { selectedFeedStore } from '../stores/selected-feed-store';

  function onClick(event: Event): void {
    const target = event.target as HTMLElement;
    const maybeListItem = target.closest('li[data-elem="list-item"]') as HTMLUListElement;

    if (!maybeListItem) {
      return;
    }

    const { url } = maybeListItem.dataset || {};

    if (url) {
      selectedFeedStore.set(url);
    }
  }
</script>

<section>
  <List on:click={onClick} />
  <Details />
</section>

<style>
  section {
    display: flex;
    flex: 1;
  }
</style>
