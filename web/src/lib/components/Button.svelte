<script lang="ts">
  export let label: string;
  export let type: 'button' | 'submit' | 'reset' = 'button';
  export let disabled: boolean = false;
  export let size: 'regular' | 'small' = 'regular';
  export let tabindex: number = 0;
</script>

<button {type} {disabled} data-size={size} {tabindex} on:click|stopPropagation>
  {label}
</button>

<style>
  button {
    font-family: 'Roboto Slab', sans-serif;
    border: 1px dashed var(--line);
    background-color: var(--background);
    cursor: pointer;
  }

  button[type='submit'] {
    font-weight: initial;
  }

  button[data-size='regular'] {
    font-size: 16px;
    margin: var(--regularMargin, 0.5em);
    padding: 0.5em 1em;
  }

  button[data-size='small'] {
    font-size: 14px;
    margin: var(--smallMargin, 0.25em);
    padding: 0.5em 0.75em;
  }

  button:not([disabled]):hover {
    background-color: var(--hover);
  }

  button:not([disabled]):active {
    background-color: var(--active);
  }

  button[disabled] {
    opacity: 50%;
    cursor: not-allowed;
  }

  @media (min-width: 1000px) {
    button[data-size='regular'] {
      font-size: 14px;
    }

    button[data-size='small'] {
      font-size: 12px;
    }
  }
</style>
