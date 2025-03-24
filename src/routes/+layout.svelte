<script lang="ts">
	import type { Snippet } from 'svelte';
	import '$lib/global.css';
	import Navbar from '$lib/components/Navbar/Navbar.svelte';

	let { children }: { children?: Snippet } = $props();
</script>

<Navbar />
<main>
	{@render children?.()}
</main>

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
