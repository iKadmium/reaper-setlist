<script lang="ts" module>
	import type { Snippet } from 'svelte';

	export interface ResponsiveActionsProps {
		primaryAction: Snippet;
		secondaryActions: Snippet;
	}
</script>

<script lang="ts">
	import { onMount } from 'svelte';
	import { browser } from '$app/environment';
	import MenuIcon from 'virtual:icons/mdi/dots-vertical';

	let { primaryAction, secondaryActions }: ResponsiveActionsProps = $props();

	let menuOpen = $state(false);
	let menuRef: HTMLDivElement;

	onMount(() => {
		if (browser) {
			function handleClickOutside(event: MouseEvent) {
				if (menuRef && !menuRef.contains(event.target as Node)) {
					menuOpen = false;
				}
			}

			function handleEscapeKey(event: KeyboardEvent) {
				if (event.key === 'Escape') {
					menuOpen = false;
				}
			}

			document.addEventListener('click', handleClickOutside);
			document.addEventListener('keydown', handleEscapeKey);

			return () => {
				document.removeEventListener('click', handleClickOutside);
				document.removeEventListener('keydown', handleEscapeKey);
			};
		}
	});

	function toggleMenu() {
		menuOpen = !menuOpen;
	}
</script>

<div class="responsive-actions">
	<!-- Primary action (always visible) -->
	<div class="primary-action">
		{@render primaryAction()}
	</div>

	<!-- Desktop: show all secondary actions -->
	<div class="secondary-actions-desktop">
		{@render secondaryActions()}
	</div>

	<!-- Mobile: hamburger menu -->
	<div class="hamburger-menu" bind:this={menuRef}>
		<button class="menu-toggle" onclick={toggleMenu} type="button" aria-label="More actions">
			<MenuIcon />
		</button>

		{#if menuOpen}
			<div class="menu-dropdown">
				{@render secondaryActions()}
			</div>
		{/if}
	</div>
</div>

<style>
	.responsive-actions {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		position: relative;
	}

	.primary-action {
		flex-shrink: 0;
	}

	.secondary-actions-desktop {
		display: flex;
		gap: 0.5rem;
	}

	.hamburger-menu {
		position: relative;
		display: none;
	}

	.menu-toggle {
		background: none;
		border: none;
		cursor: pointer;
		padding: 0.5rem;
		border-radius: 0.375rem;
		color: var(--comment);
		transition: all 0.2s ease;
		display: flex;
		align-items: center;
		justify-content: center;
		min-width: 2rem;
		min-height: 2rem;
	}

	.menu-toggle:hover {
		background-color: hsl(from var(--background) h s calc(l * 0.9));
		color: var(--foreground);
	}

	.menu-toggle:focus {
		outline: 2px solid var(--primary);
		outline-offset: 2px;
	}

	.menu-dropdown {
		position: absolute;
		top: 100%;
		right: 0;
		background-color: var(--background);
		border: 1px solid var(--current-line);
		border-radius: 0.5rem;
		box-shadow:
			0 4px 6px -1px rgb(0 0 0 / 0.1),
			0 2px 4px -2px rgb(0 0 0 / 0.1);
		z-index: 50;
		margin-top: 0.25rem;
		padding: 0.25rem;
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	/* Mobile styles */
	@media (max-width: 768px) {
		.secondary-actions-desktop {
			display: none;
		}

		.hamburger-menu {
			display: block;
		}
	}
</style>
