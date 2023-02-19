<script lang="ts">
  export let name: string;
  export let url: string;
</script>

<li>
  <p>{name}</p>
  <p>{url}</p>
</li>

<style>
  li {
    list-style: none;
    padding: 1em;
    border-bottom: 1px dashed var(--line);
    cursor: pointer;
  }

  li > * {
    margin: 0.25em 0 0.5em 0;
  }

  li > p:last-child {
    font-size: 14px;
    opacity: 75%;
  }
</style>
