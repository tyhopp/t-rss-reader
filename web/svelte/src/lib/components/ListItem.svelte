<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import Button from './Button.svelte';
  import { modalStore, ModalMode } from '../stores/modal-store';
  import type { Feed } from '../types';

  const dispatch = createEventDispatcher();

  export let feed: Feed;
  export let selected: boolean;

  function onSelect() {
    dispatch('select', feed);
  }

  function edit() {
    modalStore.open({ mode: ModalMode.edit, ...feed });
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<li data-elem="list-item" data-selected={selected} on:click={onSelect}>
  <div class="list-item-info">
    <p>{feed?.name}</p>
    <p>{feed?.url}</p>
  </div>
  <div class="list-item-actions">
    <Button label="Edit" size="small" on:click={edit} />
  </div>
</li>

<style>
  li {
    display: flex;
    list-style: none;
    padding: 0 1em;
    border-bottom: 1px dashed var(--line);
    cursor: pointer;
  }

  li:hover {
    background-color: var(--hover);
  }

  li:active {
    background-color: var(--active);
  }

  li[data-selected='true'] {
    background-color: var(--hover);
  }

  li > * {
    margin: 0.25em 0 0.5em 0;
  }

  .list-item-info {
    flex: 3;
    overflow: hidden;
  }

  .list-item-info > p:last-child {
    font-size: 14px;
    opacity: 75%;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .list-item-actions {
    flex: 1;
    display: flex;
    justify-content: flex-end;
    align-items: flex-end;
    margin-bottom: 1em;
  }
</style>
