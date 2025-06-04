<script lang="ts">
	const ssr = false;

	import Navbar from '$lib/components/Navbar/Navbar.svelte';
	import NotificationContainer from '$lib/components/Notification-Container/Notification-Container.svelte';
	import '$lib/global.css';
	import type { LayoutProps } from './$types';

	let { children, data }: LayoutProps = $props();
</script>

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
	}
</style>
