<script lang="ts">
  import { onMount } from 'svelte';
  import ListItem from '../components/ListItem.svelte';
  import Button from '../components/Button.svelte';
  import Loading from '../components/Loading.svelte';
  import { modalStore } from '../stores/modal-store';
  import { feedsStore } from '../stores/feeds-store';
  import { selectedFeedStore } from '../stores/selected-feed-store';
  import { handleJumpKeyboardEvents } from 't-rss-reader/utils/handle-jump-keyboard-events';
  import { Result } from 't-rss-reader';

  let initialized: Result = Result.none;
  let loading: boolean = false;
  let attempts: number = 1;
  let hasSelected: boolean;

  onMount(async () => {
    initialized = await feedsStore.init();

    selectedFeedStore.subscribe((selectedFeed) => (hasSelected = !!selectedFeed));
  });

  function onSelect(event: CustomEvent) {
    if (event.detail) {
      selectedFeedStore.set(event.detail);
    }
  }

  function onKeyDown(event: KeyboardEvent) {
    if ($feedsStore.length) {
      handleJumpKeyboardEvents(event, '[data-elem=list-item]');
    }
  }

  async function retry() {
    loading = true;
    initialized = await feedsStore.init();

    if (initialized === Result.failure) {
      attempts++;
    }
    loading = false;
  }
</script>

<ul on:keydown={onKeyDown} data-has-selected={hasSelected}>
  {#if initialized === Result.none}
    <Loading />
  {:else if initialized === Result.failure}
    <div>
      <p>Failed to get feeds</p>
      <p class="attempts">Attempts: {attempts}</p>
      <Button label="Retry" on:click={async () => retry()} disabled={loading} />
    </div>
  {:else if initialized === Result.success && $feedsStore?.length === 0}
    <div>
      <p>No feeds yet</p>
      <Button label="Add" on:click={() => modalStore.open()} />
    </div>
  {:else}
    {#each $feedsStore as feed}
      <ListItem on:select={onSelect} {feed} selected={feed?.url === $selectedFeedStore?.url} />
    {/each}
  {/if}
</ul>

<style>
  ul {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-width: 300px;
    overflow-y: auto;
    padding: 0 0 1em 0;
    margin: 0;
    border-left: 1px dashed var(--line);
    border-right: 1px dashed var(--line);
  }

  ul[data-has-selected='true'] {
    display: none;
  }

  @media (min-width: 600px) {
    ul {
      max-width: 350px;
      border-top: 1px dashed var(--line);
    }

    ul[data-has-selected='true'] {
      display: flex;
    }
  }

  div {
    margin: 2em 1em;
    text-align: center;
  }

  .attempts {
    font-size: 14px;
    opacity: 75%;
  }
</style>
