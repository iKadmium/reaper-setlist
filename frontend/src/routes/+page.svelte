<script lang="ts">
	import { onMount } from 'svelte';
	import Button from '$lib/components/Button/Button.svelte';
	import ItemGrid from '$lib/components/ItemGrid/ItemGrid.svelte';

	import CopyIcon from 'virtual:icons/mdi/content-copy';
	import DeleteIcon from 'virtual:icons/mdi/delete';
	import LoadIcon from 'virtual:icons/mdi/file-upload';
	import EditIcon from 'virtual:icons/mdi/pencil';
	import AddIcon from 'virtual:icons/mdi/plus';
	import type { Setlist } from '$lib/models/setlist';
	import type { Database } from '$lib/models/database';

	let sets = $state<Database<Setlist>>({}); // Initialize as empty
	let isLoading = $state(true);
	let errorMessage = $state<string | null>(null);

	onMount(async () => {
		try {
			isLoading = true;
			errorMessage = null;
			const response = await fetch('/api/sets');
			if (!response.ok) {
				const errorData = await response.json();
				throw new Error(errorData.error || `Failed to fetch sets: ${response.status}`);
			}
			const fetchedSets: Database<Setlist> = await response.json();
			sets = fetchedSets;
		} catch (err) {
			console.error('Error fetching sets:', err);
			errorMessage = err instanceof Error ? err.message : 'An unknown error occurred.';
		} finally {
			isLoading = false;
		}
	});

	function formatTitle(item: Setlist) {
		const dateString = `${new Date(item.date).toLocaleDateString()}`;
		return `${dateString} - ${item.venue}`;
	}

	async function handleDeleteClick(item: Setlist) {
		if (!item.id) {
			alert('Cannot delete a set without an ID.');
			return;
		}
		if (confirm('Are you sure you want to delete this set?')) {
			// Update this URL to point to your new external backend
			const result = await fetch(`api/sets/${item.id}`, { method: 'DELETE' });
			if (result.ok) {
				delete sets[item.id];
			} else {
				const error = await result.json();
				alert(error.error ? `Failed to delete set: ${error.error}` : 'Failed to delete set.');
			}
		}
	}

	async function handleDuplicateClick(item: Setlist) {
		const duplicated: Partial<Setlist> = { ...item, id: undefined, venue: `${item.venue} (copy)` };
		// Update this URL to point to your new external backend
		const result = await fetch(`/api/set`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify(duplicated)
		});
		if (result.ok) {
			const newSet = await result.json();
			sets[newSet.id] = newSet; // Or sets = [...sets, newSet] with Svelte 5 runes
		} else {
			const error = await result.json();
			alert(error.error ? `Failed to duplicate set: ${error.error}` : 'Failed to duplicate set.');
		}
	}
</script>

<meta:head>
	<title>Sets - Reaper Setlist</title>
</meta:head>

<h1>Sets</h1>

{#if isLoading}
	<p>Loading sets...</p>
{:else if errorMessage}
	<p style="color: red;">{errorMessage}</p>
{:else}
	<ItemGrid items={Object.values(sets)} getName={formatTitle}>
		{#snippet actions(item)}
			<Button elementType="a" color="edit" href={`/set/${item.id}/edit`}><EditIcon /></Button>
			<Button color="delete" onclick={() => handleDeleteClick(item)}><DeleteIcon /></Button>
			<Button color="primary" elementType="a" href={`/set/${item.id}/load`}><LoadIcon /></Button>
			<Button color="success" onclick={() => handleDuplicateClick(item)}><CopyIcon /></Button>
		{/snippet}
	</ItemGrid>
{/if}

<Button elementType="a" href="set/add" color="success"><AddIcon /></Button>
