<script lang="ts">
  import { Result } from 't-rss-reader';

  export let result: Result = Result.none;

  const resultMessages: Record<Result, string> = {
    [Result.none]: '',
    [Result.success]: 'Request successful',
    [Result.failure]: 'Request failed'
  };

  function getResultMessage(result: Result): string {
    return resultMessages[result];
  }

  $: resultMessage = getResultMessage(result);
</script>

{#if result !== Result.none}
  <div data-result={result}>{resultMessage}</div>
{/if}

<style>
  div {
    font-size: 14px;
    margin: var(--margin);
  }

  div[data-result='success'] {
    color: seagreen;
  }

  div[data-result='failure'] {
    color: red;
  }
</style>
