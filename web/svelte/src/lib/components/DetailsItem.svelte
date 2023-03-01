<script lang="ts">
  import type { RssFeedEntry } from '../types';

  export let entry: RssFeedEntry;

  function formatDate(dateString: string | null | undefined): string {
    if (!dateString) {
      return 'Unknown';
    }
    const date = new Date(dateString);
    return date.toDateString();
  }
</script>

<li>
  <a href={entry.url} target="_blank" rel="noopener noreferrer">
    <p class="details-item-title">{entry.title}</p>
    <p class="details-item-published">{formatDate(entry.published)}</p>
  </a>
</li>

<style>
  li {
    list-style: none;
    border-bottom: 1px dashed var(--line);
  }

  li:hover {
    background-color: var(--hover);
  }

  li:active {
    background-color: var(--active);
  }

  a {
    display: block;
    padding: 1em;
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
