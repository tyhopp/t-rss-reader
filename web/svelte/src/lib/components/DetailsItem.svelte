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

<li data-new={entry?.isNew}>
  <a href={entry.url} target="_blank" rel="noopener noreferrer">
    <p class="details-item-title">
      <span class="details-item-is-new" />
      <span>{entry.title}</span>
    </p>
    <p class="details-item-published">{formatDate(entry.published)}</p>
  </a>
</li>

<style>
  li {
    list-style: none;
    border-bottom: 1px dashed var(--line);
  }

  li:active {
    background-color: var(--active);
  }

  a {
    display: block;
    padding: 1em;
  }

  .details-item-title {
    display: flex;
    font-size: 20px;
    margin: 0.25em 0 0.5em 0;
  }

  li[data-new='false'] .details-item-is-new {
    display: none;
  }

  li[data-new='true'] .details-item-is-new {
    flex-shrink: 0;
    width: 8px;
    height: 8px;
    margin: 10px 10px 0 0;
    border-radius: 100%;
    background-color: var(--accent);
  }

  li[data-new='true'] .details-item-published {
    margin-left: 18px;
  }

  .details-item-published {
    font-size: 14px;
    opacity: 75%;
    margin: 0.75em 0;
  }

  @media (min-width: 600px) {
    li:hover {
      background-color: var(--hover);
    }
  }
</style>
