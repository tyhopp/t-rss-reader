<script lang="ts">
  import FormResultMessage from '../components/FormResultMessage.svelte';
  import Button from '../components/Button.svelte';
  import LoginService from '../services/login-service';
  import { tokenStore } from '../stores/token-store';
  import { Result, type Token } from '../types';

  let password: string | undefined;
  let loading: boolean = false;
  let result: Result = Result.none;

  async function onSubmit(): Promise<void> {
    loading = true;

    if (!password) {
      loading = false;
      return;
    }

    const response = await LoginService.login(password);
    const body: Token = await response.json();

    loading = false;
    password = undefined;

    if (response.status === 200 && 'accessToken' in body) {
      result = Result.success;
      tokenStore.set(body);
      location.assign('/');
    } else {
      result = Result.failure;
    }

    setTimeout(() => {
      result = Result.none;
    }, 3000);
  }
</script>

<form on:submit|preventDefault={onSubmit}>
  <label for="password">Enter your password</label>
  <FormResultMessage {result} --margin="0.5em" />
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

  input {
    font-size: 14px;
    background-color: var(--background);
    border: 1px solid var(--line);
    padding: 0.5em 1em;
    margin: 0.75em 0.5em 1em 0.5em;
  }

  input[disabled] {
    opacity: 75%;
    cursor: not-allowed;
  }
</style>
