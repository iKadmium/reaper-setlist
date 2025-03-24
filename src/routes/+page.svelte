<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import ItemGrid from '$lib/components/ItemGrid/ItemGrid.svelte';
	import type { SetlistDenormalized } from '$lib/server/db/schema';
	import type { PageProps } from './$types';

	import CopyIcon from 'virtual:icons/mdi/content-copy';
	import DeleteIcon from 'virtual:icons/mdi/delete';
	import LoadIcon from 'virtual:icons/mdi/file-upload';
	import EditIcon from 'virtual:icons/mdi/pencil';
	import AddIcon from 'virtual:icons/mdi/plus';

	let { data }: PageProps = $props();

	let sets = $state(data.sets);

	function formatTitle(item: SetlistDenormalized) {
		const dateString = `${new Date(item.date).toLocaleDateString()}`;
		return `${dateString} - ${item.venue}`;
	}

	async function handleDeleteClick(item: SetlistDenormalized) {
		if (confirm('Are you sure you want to delete this set?')) {
			const result = await fetch(`/api/set/${item.id}`, { method: 'DELETE' });
			if (result.ok) {
				const index = sets.findIndex((x) => x.id === item.id);
				sets.splice(index, 1);
			} else {
				const error = await result.json();
				error.error ? alert(`Failed to delete set: ${error.error}`) : 'Failed to delete set.';
			}
		}
	}

	async function handleDuplicateClick(item: SetlistDenormalized) {
		const duplicated: SetlistDenormalized = { ...item, id: undefined, venue: `${item.venue} (copy)` };
		const result = await fetch(`/api/set`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify(duplicated)
		});
		if (result.ok) {
			const newSet = await result.json();
			sets.push(newSet);
		} else {
			const error = await result.json();
			error.error ? alert(`Failed to duplicate set: ${error.error}`) : 'Failed to duplicate set.';
		}
	}
</script>

<meta:head>
	<title>Sets - Reaper Setlist</title>
</meta:head>

<h1>Sets</h1>
<ItemGrid items={sets} getName={formatTitle}>
	{#snippet actions(item)}
		<Button elementType="a" color="edit" href={`/set/${item.id}/edit`}><EditIcon /></Button>
		<Button color="delete" onclick={() => handleDeleteClick(item)}><DeleteIcon /></Button>
		<Button color="primary" elementType="a" href={`/set/${item.id}/load`}><LoadIcon /></Button>
		<Button color="success" onclick={() => handleDuplicateClick(item)}><CopyIcon /></Button>
	{/snippet}
</ItemGrid>

<Button elementType="a" href="set/add" color="success"><AddIcon /></Button>
