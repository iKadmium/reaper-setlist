<script lang="ts">
	import type { Snippet } from 'svelte';
	import LoadingIcon from 'virtual:icons/line-md/loading-loop';

	export interface ButtonProps {
		elementType?: ButtonElementType;
		onclick?: () => unknown | Promise<unknown>;
		href?: string;
		children?: Snippet;
		color?: ButtonColor;
		disabled?: boolean;
		title?: string;
		variant?: ButtonVariant;
	}

	export type ButtonColor = 'primary' | 'delete' | 'edit' | 'success';
	export type ButtonElementType = 'a' | 'button' | 'submit';
	export type ButtonVariant = 'text' | 'icon';

	let { elementType, onclick, href, children, color, disabled, title, variant = 'text' }: ButtonProps = $props();

	let busy = $state(false);
	let buttonRef = $state<HTMLButtonElement | HTMLAnchorElement>();

	function getHsl(color: ButtonColor | undefined, elementType: ButtonElementType | undefined): string {
		if (elementType === 'submit') {
			return 'var(--green)';
		}

		switch (color) {
			default:
			case 'primary':
				return 'var(--primary)';
			case 'delete':
				return 'var(--red)';
			case 'edit':
				return 'var(--yellow)';
			case 'success':
				return 'var(--green)';
		}
	}

	function isTextButton(): boolean {
		return variant === 'text';
	}

	async function handleClick(event: MouseEvent) {
		event.stopPropagation();
		busy = true;
		await onclick?.();
		busy = false;
	}

	const buttonColor = $derived(getHsl(color, elementType));
</script>

{#if elementType === 'a'}
	<a bind:this={buttonRef} class="button" class:text-button={isTextButton()} {title} style={`--button-color: ${buttonColor};`} {href}
		>{@render children?.()}
	</a>
{:else}
	<button
		bind:this={buttonRef}
		class="button"
		class:text-button={isTextButton()}
		type={elementType === 'submit' ? 'submit' : 'button'}
		style={`--button-color: ${buttonColor};`}
		{title}
		aria-label={title}
		disabled={busy || disabled}
		onclick={handleClick}
	>
		{#if busy}
			<LoadingIcon />
		{:else}
			{@render children?.()}
		{/if}
	</button>
{/if}

<style>
	.button:not(:disabled) {
		cursor: pointer;
	}

	.button:disabled {
		background-color: hsl(from var(--button-color) h 0% l);
	}

	.button {
		display: flex;
		padding: 0.5rem 1rem;
		border: 1px solid var(--text);
		border-radius: 1rem;
		box-sizing: border-box;

		align-items: center;
		color: var(--black);
		font-weight: bold;
		font-size: 1.5rem;
		text-decoration: none;
		background-color: var(--button-color);
		line-height: 1.5rem;

		justify-content: center;

		&:not(:disabled):hover {
			background-color: hsl(from var(--button-color) h 100% calc(l * 0.9));
		}
	}

	/* Text button styling - smaller font size, more padding, and responsive layout */
	.button.text-button {
		font-size: 1rem;
		padding: 0.75rem 1.5rem;
		line-height: 1.2;
		gap: 0.5rem;
		width: auto;
		flex-shrink: 0;
	}

	@media (max-width: 768px) {
		/* Only make text buttons full width on mobile */
		.button.text-button {
			width: 100%;
			padding: 0.75rem 1rem;
		}

		/* Keep icon buttons at their natural size */
		.button:not(.text-button) {
			width: auto;
		}
	}
</style>
