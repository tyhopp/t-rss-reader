<script lang="ts">
  import Button from './Button.svelte';
  import { modalStore } from '../stores/modal-store';

  export let name: string;
  export let url: string;
  export let selected: boolean;

  function edit() {
    modalStore.open({ editing: true, name, url });
  }
</script>

<li data-elem="list-item" data-url={url} data-selected={selected}>
  <div class="list-item-info">
    <p>{name}</p>
    <p>{url}</p>
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
