<script lang="ts">
  import DetailsItem from './DetailsItem.svelte';

  // TODO: Remove
  let feeds: Array<{ title: string; date: string }> = new Array(100).fill({
    title: `Strange quirks of Safari's dark color scheme handling`,
    date: `2022-08-08`
  });
</script>

<ul>
  {#each feeds as { title, date }}
    <DetailsItem {title} {date} />
  {/each}
</ul>

<style>
  ul {
    display: none;
  }

  @media (min-width: 600px) {
    ul {
      flex: 1;
      display: flex;
      flex-direction: column;
      overflow-y: auto;
      padding: 0;
      margin: 0;
      border-top: 1px dashed var(--line);
      border-right: 1px dashed var(--line);
    }
  }
</style>
