<script lang="ts">
  export let label: string;
  export let type: 'button' | 'submit' | 'reset' = 'button';
  export let disabled: boolean = false;
</script>

<button {type} {disabled} on:click>
  {label}
</button>

<style>
  button {
    font-family: 'Roboto Slab', sans-serif;
    border: 1px dashed var(--line);
    background-color: var(--background);
    margin: 0.5em;
    padding: 0.5em 1em;
    cursor: pointer;
  }

  button:not([disabled]):hover {
    background-color: var(--hover);
  }

  button:not([disabled]):active {
    background-color: var(--active);
  }

  button[disabled] {
    cursor: not-allowed;
  }
</style>
