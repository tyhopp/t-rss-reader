<div>
  <span />
</div>

<style>
  @keyframes spinner {
    to {
      transform: rotate(360deg);
    }
  }

  div {
    position: relative;
    margin: var(--margin);
  }

  span:before {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 20px;
    height: 20px;
    margin-top: -10px;
    margin-left: -10px;
    border-radius: 50%;
    border: 2px solid var(--line);
    border-top-color: var(--accent);
    animation: spinner 0.6s linear infinite;
  }

  @keyframes animate {
    0% {
      height: 100%;
    }
    100% {
      height: 0%;
    }
  }
</style>
