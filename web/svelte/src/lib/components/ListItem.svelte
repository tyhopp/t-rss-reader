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
    width: 350px;
    height: 60px;
  }
</style>