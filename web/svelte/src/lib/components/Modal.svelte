<script lang="ts">
  import { modalStore } from '../stores/modal-store';

  function onKeyDown(event: KeyboardEvent): void {
    if (event.key === 'Escape') {
      modalStore.close();
    }
  }
</script>

{#if $modalStore.open}
  <div
    id="modal"
    role="dialog"
    aria-labelledby="modal-title"
    aria-modal="true"
    on:click={() => modalStore.close()}
    on:keydown={onKeyDown}
  >
    <div id="modal-content" on:click|stopPropagation on:keydown>
      <h1 id="modal-title">
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
    -webkit-backdrop-filter: blur(3px);
  }

  #modal-content {
    display: flex;
    flex-direction: column;
    min-width: 300px;
    max-width: 450px;
    padding: 2em;
    margin-top: 1em;
    border: 1px solid var(--line);
    background-color: var(--background);
  }

  @media (min-width: 1000px) {
    #modal-content {
      margin-top: 5em;
    }
  }

  h1 {
    font-size: 20px;
    margin: 0 0 0.75em 0;
  }
</style>
