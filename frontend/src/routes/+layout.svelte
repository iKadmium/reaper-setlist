<script lang="ts">
	import Navbar from '$lib/components/Navbar/Navbar.svelte';
	import NotificationContainer from '$lib/components/Notification-Container/Notification-Container.svelte';
	import '$lib/global.css';
	import type { LayoutProps } from './$types';

	let { children, data }: LayoutProps = $props();
	function getBaseUrl() {
		const url = new URL(window.location.href);
		return url.origin + url.pathname;
	}
</script>

<svelte:head>
	<base href={getBaseUrl()} />
	<title>Reaper Setlist</title>
</svelte:head>

<Navbar setupComplete={data.setupComplete} />

<main>
	{@render children?.()}
</main>

<NotificationContainer />

<style>
	main {
		margin: 0 auto;
		width: 100%;
		max-width: 800px;
		background: var(--background);
		padding: 2rem;
		border-radius: 1rem;
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		gap: 0.5rem;
		box-sizing: border-box;
	}

	@media (max-width: 768px) {
		main {
			padding: 1rem;
			border-radius: 0;
		}
	}
</style>
