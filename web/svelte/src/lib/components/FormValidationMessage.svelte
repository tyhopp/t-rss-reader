<script lang="ts">
  export let validationMessage: string | undefined;
</script>

{#if !!validationMessage}
  <div>{validationMessage}</div>
{/if}

<style>
  div {
    font-size: 14px;
    margin: var(--margin);
    color: red;
  }
</style>
