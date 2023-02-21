<script lang="ts">
  import { modalOpen } from '../stores/modal-store';

  function onBackgroundClick() {
    modalOpen.update((current) => !current);
  }
</script>

{#if $modalOpen}
  <!-- TODO: Implement focus handling with keyboard -->
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div id="modal" on:click={onBackgroundClick}>
    <div id="modal-content" on:click|stopPropagation>
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
    margin: 0 0 1em 0;
  }
</style>
