<script lang="ts">
  import Modal from '../components/Modal.svelte';
  import FormResultMessage from '../components/FormResultMessage.svelte';
  import Button from '../components/Button.svelte';
  import { FeedsService } from '../services/feeds-service';
  import { modalStore } from '../stores/modal-store';
  import { feedsStore } from '../stores/feeds-store';
  import { Result } from '../types';
  import type { Feeds } from '../types';
  import FormValidationMessage from '$lib/components/FormValidationMessage.svelte';

  let name: string | undefined;
  let url: string | undefined;
  let loading: boolean = false;
  let validationMessage: string | undefined;
  let result: Result = Result.none;
  let feeds: Feeds;

  $: maySubmit = validate(name, url, loading);

  modalStore.subscribe((open) => {
    if (!open) {
      name = undefined;
      url = undefined;
      loading = false;
      result = Result.none;
    }
  });

  feedsStore.subscribe((currentFeeds) => (feeds = currentFeeds));

  function validate(name: string | undefined, url: string | undefined, loading: boolean) {
    validationMessage = '';

    if (loading || !name || !url) {
      return false;
    }

    if (!url.startsWith('https://')) {
      validationMessage = 'URL must start with https';
      return false;
    }

    if (feeds.some((feed) => feed.url === url)) {
      validationMessage = 'URL must be unique';
      return false;
    }

    return true;
  }

  async function onSubmit(): Promise<void> {
    loading = true;

    const feedsServiceInstance = new FeedsService();

    if (!name || !url) {
      loading = false;
      return;
    }

    const response = await feedsServiceInstance.putFeed(url, name);

    if (response.status === 200) {
      result = Result.success;
      loading = false;

      const body = await response.json();

      feedsStore.add(body.feed);

      modalStore.toggle();
    } else {
      loading = false;
      result = Result.failure;
    }

    setTimeout(() => {
      result = Result.none;
    }, 3000);
  }
</script>

<Modal>
  <span slot="title">Add feed</span>
  <span slot="body">
    <div class="add-feed-modal-body">
      <form on:submit|preventDefault={onSubmit}>
        <FormValidationMessage {validationMessage} --margin="0 0 1em 0" />
        <FormResultMessage {result} --margin="0 0 1em 0" />
        <div>
          <label for="name">Name</label>
          <input bind:value={name} type="text" name="name" required disabled={loading} />
        </div>
        <div>
          <label for="url">URL</label>
          <input bind:value={url} type="text" name="url" required disabled={loading} />
        </div>
        <div class="add-feed-modal-buttons">
          <Button label="Cancel" on:click={() => modalStore.toggle()} disabled={loading} />
          <Button type="submit" label={loading ? 'Adding...' : 'Add'} disabled={!maySubmit} />
        </div>
      </form>
    </div>
  </span>
</Modal>

<style>
  .add-feed-modal-body {
    display: flex;
    flex-direction: column;
  }

  form div {
    display: grid;
    grid-template-columns: 1fr 4fr;
    margin: 0.25em 0;
  }

  form div > * {
    display: flex;
    align-items: center;
  }

  input {
    font-size: 14px;
    font-family: 'Roboto Slab', sans-serif;
    background-color: var(--background);
    border: 1px solid var(--line);
    padding: 0.5em 1em;
    margin: 0.5rem;
  }

  input[disabled] {
    opacity: 75%;
    cursor: not-allowed;
  }

  .add-feed-modal-buttons {
    display: flex;
    justify-content: flex-end;
    margin-top: 1em;
  }
</style>
