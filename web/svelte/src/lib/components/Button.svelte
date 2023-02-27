<script lang="ts">
  export let label: string;
  export let type: 'button' | 'submit' | 'reset' = 'button';
  export let disabled: boolean = false;
  export let size: 'regular' | 'small' = 'regular';
</script>

<button {type} {disabled} data-size={size} on:click|stopPropagation>
  {label}
</button>

<style>
  button {
    font-family: 'Roboto Slab', sans-serif;
    border: 1px dashed var(--line);
    background-color: var(--background);
    cursor: pointer;
  }

  button[data-size='regular'] {
    margin: 0.5em;
    padding: 0.5em 1em;
  }

  button[data-size='small'] {
    font-size: 12px;
    margin: 0.25em;
    padding: 0.5em 0.75em;
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
