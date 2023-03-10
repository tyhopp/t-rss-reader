<script lang="ts">
  import { onMount } from 'svelte';
  import { tokenStore } from '../stores/token-store';
  import { modalStore } from '../stores/modal-store';
  import { selectedFeedStore } from '../stores/selected-feed-store';
  import Button from './Button.svelte';
  import type { Feed } from '../types';

  let disabled: boolean = true;
  let selectedFeed: Feed | undefined;

  onMount(() => {
    tokenStore.subscribe((store) => {
      const { maybeValid } = store || {};

      if (maybeValid) {
        disabled = false;
      }
    });

    selectedFeedStore.subscribe((currentSelectedFeed) => (selectedFeed = currentSelectedFeed));
  });
</script>

<header data-selected={!!selectedFeed}>
  <h1 class="header-title-desktop">t-rss-reader</h1>
  <div class="header-buttons-left-mobile">
    <Button label="Feeds" on:click={() => selectedFeedStore.set(undefined)} />
  </div>
  <h1 class="header-title-mobile">{selectedFeed?.name}</h1>
  <div class="header-buttons-right">
    <Button label="Add" {disabled} on:click={() => modalStore.open()} />
  </div>
</header>

<style>
  h1 {
    font-weight: 700;
    font-size: 18px;
  }

  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 50px;
    padding: 0 1em;
    border-bottom: 1px dashed var(--line);
  }

  .header-title-mobile {
    flex: 2;
    padding: 0 0.5em;
    text-align: center;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .header-buttons-left-mobile {
    flex: 1;
    margin-left: -1em;
  }

  .header-buttons-right {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: flex-end;
    margin-right: -0.75em;
  }

  header[data-selected='false'] .header-buttons-left-mobile,
  header[data-selected='false'] .header-title-mobile {
    display: none;
  }

  header[data-selected='true'] .header-title-desktop {
    display: none;
  }

  @media (min-width: 600px) {
    h1 {
      font-size: 20px;
    }

    header {
      border-bottom: none;
    }

    .header-title-desktop {
      display: initial !important;
    }

    .header-buttons-left-mobile,
    .header-title-mobile {
      display: none;
    }

    .header-buttons-right {
      margin-right: -0.5em;
    }
  }

  @media (min-width: 1000px) {
    header {
      padding: 0;
    }
  }
</style>
