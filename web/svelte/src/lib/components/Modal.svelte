<script lang="ts">
  import { modalStore } from '../stores/modal-store';

  function onKeyDown(event: KeyboardEvent): void {
    if (event.key === 'Escape') {
      modalStore.toggle();
    }
  }
</script>

{#if $modalStore}
  <div id="modal" on:click={modalStore.toggle} on:keydown={onKeyDown}>
    <div id="modal-content" on:click|stopPropagation on:keydown>
      <h1>
        <slot name="title" />
      </h1>
      <slot name="body" />
    </div>
  </div>
{/if}

<style>
  #modal {
    display: flex;
    flex-direction: column;
    align-items: center;
    position: fixed;
    left: 0;
    top: 0;
    z-index: 2;
    width: 100vw;
    height: 100vh;
    transition: all 0.2s linear;
    backdrop-filter: blur(3px);
  }

  #modal-content {
    display: flex;
    flex-direction: column;
    min-width: 300px;
    max-width: 450px;
    padding: 2em;
    margin-top: 20%;
    border: 1px solid var(--line);
    background-color: var(--background);
  }

  h1 {
    font-size: 20px;
    margin: 0 0 0.75em 0;
  }
</style>
