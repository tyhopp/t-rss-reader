<script lang="ts">
  export let name: string;
  export let url: string;
</script>

<li>
  <p class="list-item-name">{name}</p>
  <p class="list-item-url">{url}</p>
</li>

<style>
  li {
    list-style: none;
    width: 350px;
    height: 60px;
  }

  .list-item-name {
    font-weight: 500;
  }

  .list-item-url {
    font-size: 14px;
  }
</style>