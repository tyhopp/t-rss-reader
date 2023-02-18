<script lang="ts">
  export let label: string
</script>

<button type="button">
  {label}
</button>

<style>
  button {
    font-family: 'Okomito Regular', 'sans-serif';
    border: 1px dashed var(--line);
    background-color: transparent;
    margin: 0.5em;
    padding: 0.5em 1em;
  }
</style>