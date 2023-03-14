<script lang="ts">
  import Modal from '../components/Modal.svelte';
  import FormResultMessage from '../components/FormResultMessage.svelte';
  import Button from '../components/Button.svelte';
  import FeedsService from '../services/feeds-service';
  import { modalStore, ModalMode } from '../stores/modal-store';
  import { feedsStore } from '../stores/feeds-store';
  import { selectedFeedStore } from '../stores/selected-feed-store';
  import { Result } from '../types';
  import type { Feeds } from '../types';
  import FormValidationMessage from '$lib/components/FormValidationMessage.svelte';

  enum InFlightAction {
    none = 'none',
    editing = 'editing',
    deleting = 'deleting',
    adding = 'adding'
  }

  let feeds: Feeds;
  let inFlightAction: InFlightAction = InFlightAction.none;
  let result: Result = Result.none;
  let validationMessage: string | undefined;

  $: title = $modalStore.mode === ModalMode.edit ? 'Edit feed' : 'Add feed';
  $: deleteButtonLabel = getDeleteButtonLabel(inFlightAction);
  $: submitButtonLabel = getSubmitButtonLabel($modalStore.mode, inFlightAction);
  $: maySubmit = validate($modalStore.name, $modalStore.url, $modalStore.mode, inFlightAction);

  modalStore.subscribe(({ open }) => {
    if (!open) {
      inFlightAction = InFlightAction.none;
      result = Result.none;
    }
  });

  feedsStore.subscribe((currentFeeds) => (feeds = currentFeeds));

  function getDeleteButtonLabel(inFlightAction: InFlightAction): string {
    return inFlightAction === InFlightAction.deleting ? 'Deleting...' : 'Delete';
  }

  function getSubmitButtonLabel(mode: ModalMode, inFlightAction: InFlightAction): string {
    if (mode === ModalMode.edit) {
      return inFlightAction === InFlightAction.editing ? 'Editing...' : 'Submit';
    }

    return inFlightAction === InFlightAction.adding ? 'Adding...' : 'Add';
  }

  function validate(
    name: string | undefined,
    url: string | undefined,
    mode: ModalMode,
    inFlightAction: InFlightAction
  ): boolean {
    validationMessage = '';

    if (!name || !url) {
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

    if (inFlightAction !== InFlightAction.none) {
      return false;
    }

    return true;
  }

  async function onDelete(): Promise<void> {
    inFlightAction = InFlightAction.deleting;

    if (!$modalStore.url) {
      inFlightAction = InFlightAction.none;
      return;
    }

    const response = await FeedsService.deleteFeed($modalStore.url);

    if (response.status) {
      result = Result.success;
      inFlightAction = InFlightAction.none;

      feedsStore.update((prevFeeds) => {
        return prevFeeds.filter((prevFeed) => prevFeed.url !== $modalStore.url);
      });

      selectedFeedStore.set(undefined);

      modalStore.close();
    } else {
      inFlightAction = InFlightAction.none;
      result = Result.failure;
    }

    setTimeout(() => {
      result = Result.none;
    }, 3000);
  }

  async function onSubmit(): Promise<void> {
    inFlightAction =
      $modalStore.mode === ModalMode.edit ? InFlightAction.editing : InFlightAction.adding;

    if (!$modalStore.name || !$modalStore.url) {
      inFlightAction = InFlightAction.none;
      return;
    }

    const response = await FeedsService.putFeed($modalStore.url, $modalStore.name);

    if (response.status === 200) {
      result = Result.success;
      inFlightAction = InFlightAction.none;

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
      inFlightAction = InFlightAction.none;
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
    <div class="upsert-feed-modal-body">
      <form on:submit|preventDefault={onSubmit}>
        <FormValidationMessage {validationMessage} --margin="0 0 1em 0" />
        <FormResultMessage {result} --margin="0 0 1em 0" />
        <div>
          <label for="name">Name</label>
          <!--
            svelte-ignore a11y-autofocus
            Focusing on the first input in a modal dialog is recommended by the W3C.
            See https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/dialog/.
          -->
          <input
            bind:value={$modalStore.name}
            autofocus={true}
            type="text"
            name="name"
            required
            disabled={inFlightAction !== InFlightAction.none}
          />
        </div>
        <div>
          <label for="url">URL</label>
          <input
            bind:value={$modalStore.url}
            type="text"
            name="url"
            required
            disabled={inFlightAction !== InFlightAction.none || $modalStore.mode === ModalMode.edit}
          />
        </div>
        <div class="upsert-feed-modal-buttons">
          <Button
            label="Cancel"
            on:click={() => modalStore.close()}
            disabled={inFlightAction !== InFlightAction.none}
          />
          {#if $modalStore.mode === ModalMode.edit}
            <Button
              label={deleteButtonLabel}
              on:click={onDelete}
              disabled={inFlightAction !== InFlightAction.none}
            />
          {/if}
          <Button type="submit" label={submitButtonLabel} disabled={!maySubmit} />
        </div>
      </form>
    </div>
  </span>
</Modal>

<style>
  .upsert-feed-modal-body {
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
    padding: 0.5em 1em;
    margin: 0.5rem;
  }

  .upsert-feed-modal-buttons {
    display: flex;
    justify-content: flex-end;
    margin-top: 1em;
  }
</style>
