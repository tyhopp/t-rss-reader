<script lang="ts">
  export let title: string;
  export let date: string;
</script>

<li>
  <p>{title}</p>
  <time datetime={date}>{date}</time>
</li>

<style>
  li {
    list-style: none;
    padding: 1em;
    border-bottom: 1px dashed var(--line);
  }

  li > * {
    margin: 0.25em 0 0.5em 0;
  }

  p {
    font-size: 20px;
    margin: 0.25em 0 0.5em 0;
  }

  time {
    display: block;
    font-size: 14px;
    opacity: 75%;
    margin: 0.7f5em 0;
  }
</style>
