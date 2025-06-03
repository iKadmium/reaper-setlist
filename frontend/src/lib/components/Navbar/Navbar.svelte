<script lang="ts">
	export interface NavbarProps {
		setupComplete?: boolean;
	}
	import { page } from '$app/state';

	let { setupComplete = false }: NavbarProps = $props();
</script>

<nav>
	<ul class="nav">
		{#if setupComplete}
			<li><a href="/" class:active={page.url.pathname === '/'}>Sets</a></li>
			<li><a href="/song" class:active={page.url.pathname === '/song'}>Songs</a></li>
		{/if}
		<li><a href="/setup" class:active={page.url.pathname === '/setup'}>Setup</a></li>
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
