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
	}

	export type ButtonColor = 'primary' | 'delete' | 'edit' | 'success';
	export type ButtonElementType = 'a' | 'button' | 'submit';

	let { elementType, onclick, href, children, color, disabled, title }: ButtonProps = $props();

	let busy = $state(false);

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

	async function handleClick(event: MouseEvent) {
		event.stopPropagation();
		busy = true;
		await onclick?.();
		busy = false;
	}

	const buttonColor = $derived(getHsl(color, elementType));
</script>

{#if elementType === 'a'}
	<a class="button" {title} style={`--button-color: ${buttonColor};`} {href}>{@render children?.()} </a>
{:else}
	<button
		class="button"
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

		&:not(:disabled):hover {
			background-color: hsl(from var(--button-color) h 100% calc(l * 0.9));
		}
	}

	@media (max-width: 768px) {
		.button {
			width: 100%;
		}
	}
</style>
