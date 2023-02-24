<script lang="ts">
  import type { RssFeedEntry } from '../types';

  export let entry: RssFeedEntry;
</script>

<li>
  <a href={entry.id} target="_blank" rel="noopener noreferrer">
    <p class="details-item-title">{entry.title}</p>
    <p class="details-item-published">Published: {entry.published}</p>
    <p class="details-item-updated">Updated: {entry.updated}</p>
  </a>
</li>

<style>
  li {
    list-style: none;
    padding: 1em;
    border-bottom: 1px dashed var(--line);
  }

  li:hover {
    background-color: var(--hover);
  }

  li:active {
    background-color: var(--active);
  }

  li > * {
    margin: 0.25em 0 0.5em 0;
  }

  .details-item-title {
    font-size: 20px;
    margin: 0.25em 0 0.5em 0;
  }

  .details-item-published,
  .details-item-updated {
    font-size: 14px;
    opacity: 75%;
    margin: 0.75em 0;
  }
</style>
