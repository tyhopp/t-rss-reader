<script lang="ts">
  import Button from '../components/Button.svelte';
  import { LoginService } from '../services/login-service';
  import { LOCAL_STORAGE_ACCESS_TOKEN_KEY } from '../constants';

  let LoginServiceInstance = new LoginService();

  type Result = 'none' | 'success' | 'failure';

  const resultMessages: Record<Result, string> = {
    none: '',
    success: 'Success!',
    failure: 'Failed to authorize.'
  };

  let password: string | undefined;
  let loading: boolean = false;
  let result: Result = 'none';

  function getResultMessage(result: Result): string {
    return resultMessages[result];
  }

  $: resultMessage = getResultMessage(result);

  async function onSubmit(): Promise<void> {
    loading = true;

    if (!password) {
      loading = false;
      return;
    }

    const response = await LoginServiceInstance.login(password);

    loading = false;
    password = undefined;

    if ('accessToken' in response) {
      localStorage.setItem(LOCAL_STORAGE_ACCESS_TOKEN_KEY, JSON.stringify(response));
      result = 'success';
    } else {
      result = 'failure';
    }

    setTimeout(() => {
      result = 'none';
    }, 3000);
  }
</script>

<form on:submit|preventDefault={onSubmit}>
  <label for="password">Enter your password</label>
  {#if result !== 'none'}
    <span data-result={result}>{resultMessage}</span>
  {/if}
  <input name="password" type="password" required bind:value={password} disabled={loading} />
  <Button
    type="submit"
    label={loading ? 'Authorizing...' : 'Log in'}
    disabled={!password || loading}
  />
</form>

<style>
  form {
    display: flex;
    flex-direction: column;
    max-width: 300px;
    margin: 0 auto;
  }

  label {
    margin: 0.5em;
  }

  span {
    font-size: 14px;
    margin: 0.5em;
  }

  span[data-result='success'] {
    color: seagreen;
  }

  span[data-result='failure'] {
    color: red;
  }

  input {
    font-size: 14px;
    background-color: var(--background);
    border: 1px solid var(--line);
    padding: 0.5em 1em;
    margin: 0.5em;
  }

  input[disabled] {
    opacity: 75%;
    cursor: not-allowed;
  }
</style>
