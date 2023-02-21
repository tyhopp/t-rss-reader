<script>
  import Modal from '../components/Modal.svelte';
  import Button from '../components/Button.svelte';
  import { modalOpen } from '../stores/modal-store';
</script>

<Modal>
  <span slot="title">Add feed</span>
  <span slot="body">
    <div class="add-feed-modal-body">
      <form>
        <div>
          <label for="feed-name">Name</label>
          <input type="text" name="feed-name" required />
        </div>
        <div>
          <label for="feed-url">URL</label>
          <input type="text" name="feed-url" required />
        </div>
      </form>
      <div class="add-feed-modal-buttons">
        <Button label="Cancel" on:click={() => modalOpen.update((current) => !current)} />
        <Button label="Add" />
      </div>
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

  .add-feed-modal-buttons {
    display: flex;
    justify-content: flex-end;
    margin-top: 0.5em;
  }
</style>
