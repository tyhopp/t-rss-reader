/**
 * Handle focus for lists when jump keys are pressed.
 * Allows reasonable keyboard navigation within and between the list and details widgets.
 *
 * Handled keys:
 * Home - focus on first item in the list
 * End - focus on last item in the list
 */
export function handleJumpKeyboardEvents(event: KeyboardEvent, selector: string): void {
  if (event.key === 'Home') {
    const firstItem = document.querySelector(selector) as HTMLElement;

    if (firstItem) {
      firstItem.focus();
    }
  }

  if (event.key === 'End') {
    const items = document.querySelectorAll(selector);
    const lastItem = items?.[items.length - 1] as HTMLElement;

    if (lastItem) {
      lastItem.focus();
    }
  }
}
