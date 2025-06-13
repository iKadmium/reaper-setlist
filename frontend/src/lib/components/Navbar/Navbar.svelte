<script lang="ts">
	import { page } from '$app/state';
	import { configuration } from '$lib';

	// Optional prop for backward compatibility, but prefer using the store
	export interface NavbarProps {
		setupComplete?: boolean;
	}

	let { setupComplete: propSetupComplete }: NavbarProps = $props();

	// Use the store value if available, otherwise fall back to prop
	const setupComplete = $derived(configuration.isSetupComplete ?? propSetupComplete ?? false);
</script>

<nav>
	<ul class="nav">
		{#if setupComplete}
			<li><a href="#/" class:active={page.url.hash === `#/` || page.url.hash === ''}>Sets</a></li>
			<li><a href="#/song" class:active={page.url.hash === `#/song`}>Songs</a></li>
			<li><a href="#/play" class:active={page.url.hash === `#/play`}>Play</a></li>
		{/if}
		<li><a href="#/setup" class:active={page.url.hash === `#/setup` || page.url.hash.startsWith(`#/setup/`)}>Setup</a></li>
	</ul>
</nav>

<style>
	nav {
		margin: 0;
		width: 100%;
	}

	.nav {
		display: flex;
		justify-content: center;
		margin: 0;
		padding: 1rem;
		padding-inline-start: 0;
		font-size: x-large;
	}

	.nav li {
		list-style-type: none;
	}

	.nav a {
		color: white;
		text-decoration: none;
		padding: 1rem;

		&.active {
			color: var(--purple);
		}
	}
</style>
