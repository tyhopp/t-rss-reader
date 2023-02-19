<script lang="ts">
  export let type: 'button' | 'submit' | 'reset' = 'button';
  export let label: string;
  export let disabled: boolean;
</script>

<button {type} {disabled}>
  {label}
</button>

<style>
  button {
    font-family: 'Roboto Slab', sans-serif;
    border: 1px dashed var(--line);
    background-color: transparent;
    margin: 0.5em;
    padding: 0.5em 1em;
    cursor: pointer;
  }

  button[disabled] {
    cursor: not-allowed;
  }
</style>
