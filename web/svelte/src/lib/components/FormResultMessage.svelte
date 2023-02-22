<script lang="ts">
  import type { FormResult } from '../types';

  export let result: FormResult = 'none';

  const resultMessages: Record<FormResult, string> = {
    none: '',
    success: 'Request successful',
    failure: 'Request failed'
  };

  function getResultMessage(result: FormResult): string {
    return resultMessages[result];
  }

  $: resultMessage = getResultMessage(result);
</script>

{#if result !== 'none'}
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
