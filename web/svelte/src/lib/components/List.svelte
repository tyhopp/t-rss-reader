<script lang="ts">
  import ListItem from "./ListItem.svelte"

  // TODO: Remove
  let feeds: Array<{ name: string, url: string }> = [
    {
      name: `Ty Hopp's programming blog`,
      url: `https://tyhopp.com/rss.xml`
    }
  ]
</script>

<ul>
  {#each feeds as { name, url }}
    <ListItem name={name} url={url} />
  {/each}
</ul>