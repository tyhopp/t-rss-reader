<script lang="ts">
  import Modal from '../components/Modal.svelte';
  import FormResultMessage from '../components/FormResultMessage.svelte';
  import Button from '../components/Button.svelte';
  import { FeedsService } from '../services/feeds-service';
  import { modalStore, ModalMode } from '../stores/modal-store';
  import { feedsStore } from '../stores/feeds-store';
  import { Result } from '../types';
  import type { Feeds } from '../types';
  import FormValidationMessage from '$lib/components/FormValidationMessage.svelte';

  let loading: boolean = false;
  let validationMessage: string | undefined;
  let result: Result = Result.none;
  let feeds: Feeds;

  $: title = $modalStore.mode === ModalMode.edit ? 'Edit feed' : 'Add feed';
  $: submitButtonLabel = getSubmitButtonLabel($modalStore.mode, loading);
  $: maySubmit = validate($modalStore.name, $modalStore.url, $modalStore.mode, loading);

  modalStore.subscribe(({ open }) => {
    if (!open) {
      loading = false;
      result = Result.none;
    }
  });

  feedsStore.subscribe((currentFeeds) => (feeds = currentFeeds));

  function getSubmitButtonLabel(mode: ModalMode, loading: boolean): string {
    if (mode === ModalMode.edit && loading) {
      return 'Editing...';
    }

    if (mode === ModalMode.add && loading) {
      return 'Adding...';
    }

    return 'Submit';
  }

  function validate(
    name: string | undefined,
    url: string | undefined,
    mode: ModalMode,
    loading: boolean
  ): boolean {
    validationMessage = '';

    if (loading || !name || !url) {
      return false;
    }

    if (!url.startsWith('https://')) {
      validationMessage = 'URL must start with https://';
      return false;
    }

    if (mode === ModalMode.add && feeds.some((feed) => feed.url === url)) {
      validationMessage = 'URL must be unique';
      return false;
    }

    return true;
  }

  async function onDelete(): Promise<void> {
    loading = true;

    const feedsServiceInstance = new FeedsService();

    if (!$modalStore.url) {
      loading = false;
      return;
    }

    const response = await feedsServiceInstance.deleteFeed($modalStore.url);

    if (response.status) {
      result = Result.success;
      loading = false;

      feedsStore.update((prevFeeds) => {
        return prevFeeds.filter((prevFeed) => prevFeed.url !== $modalStore.url);
      });

      modalStore.close();
    } else {
      loading = false;
      result = Result.failure;
    }

    setTimeout(() => {
      result = Result.none;
    }, 3000);
  }

  async function onSubmit(): Promise<void> {
    loading = true;

    const feedsServiceInstance = new FeedsService();

    if (!$modalStore.name || !$modalStore.url) {
      loading = false;
      return;
    }

    const response = await feedsServiceInstance.putFeed($modalStore.url, $modalStore.name);

    if (response.status === 200) {
      result = Result.success;
      loading = false;

      const body = await response.json();

      feedsStore.update((prevFeeds) => {
        if ($modalStore.mode === ModalMode.edit) {
          return prevFeeds.map((prevFeed) =>
            prevFeed.url === body.feed.url ? body.feed : prevFeed
          );
        } else {
          return [...prevFeeds, body.feed];
        }
      });

      modalStore.close();
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
  <span slot="title">{title}</span>
  <span slot="body">
    <div class="add-feed-modal-body">
      <form on:submit|preventDefault={onSubmit}>
        <FormValidationMessage {validationMessage} --margin="0 0 1em 0" />
        <FormResultMessage {result} --margin="0 0 1em 0" />
        <div>
          <label for="name">Name</label>
          <input
            bind:value={$modalStore.name}
            type="text"
            name="name"
            required
            disabled={loading}
          />
        </div>
        <div>
          <label for="url">URL</label>
          <input
            bind:value={$modalStore.url}
            type="text"
            name="url"
            required
            disabled={loading || $modalStore.mode === ModalMode.edit}
          />
        </div>
        <div class="add-feed-modal-buttons">
          <Button label="Cancel" on:click={() => modalStore.close()} disabled={loading} />
          {#if $modalStore.mode === ModalMode.edit}
            <Button label="Delete" on:click={onDelete} disabled={loading} />
          {/if}
          <Button type="submit" label={submitButtonLabel} disabled={!maySubmit} />
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
