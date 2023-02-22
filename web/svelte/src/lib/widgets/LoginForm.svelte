<script lang="ts">
  import FormResultMessage from '../components/FormResultMessage.svelte';
  import Button from '../components/Button.svelte';
  import { LoginService } from '../services/login-service';
  import { tokenStore } from '../stores/token-store';
  import type { FormResult } from '../types';

  let LoginServiceInstance = new LoginService();

  let password: string | undefined;
  let loading: boolean = false;
  let result: FormResult = 'none';

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
      result = 'success';
      tokenStore.set(response);
      location.assign('/');
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
  <FormResultMessage {result} --margin="0.5em" />
  <!-- svelte-ignore a11y-autofocus -->
  <input
    name="password"
    type="password"
    required
    autofocus
    bind:value={password}
    disabled={loading}
  />
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
