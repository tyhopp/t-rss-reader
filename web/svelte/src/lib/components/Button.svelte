<script lang="ts">
  export let label: string;
</script>

<button type="button">
  {label}
</button>

<style>
  button {
    font-family: 'Roboto Slab', sans-serif;
    font-weight: 500;
    border: 1px dashed var(--line);
    background-color: transparent;
    margin: 0.5em;
    padding: 0.5em 1em;
    cursor: pointer;
  }
</style>
