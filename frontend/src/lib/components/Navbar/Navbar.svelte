<script lang="ts">
	export interface NavbarProps {
		setupComplete?: boolean;
	}
	import { base } from '$app/paths';
	import { page } from '$app/state';

	let { setupComplete = false }: NavbarProps = $props();
	console.log({ pathname: page.url });
</script>

<nav>
	<ul class="nav">
		{#if setupComplete}
			<li><a href={`${base}/#/`} class:active={page.url.hash === `#/`}>Sets</a></li>
			<li><a href={`${base}/#/song`} class:active={page.url.hash === `#/song`}>Songs</a></li>
		{/if}
		<li><a href={`${base}/#/setup`} class:active={page.url.hash === `#/setup` || page.url.hash.startsWith(`${base}/#/setup/`)}>Setup</a></li>
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
