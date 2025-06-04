<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import ItemGrid from '$lib/components/ItemGrid/ItemGrid.svelte';

	import type { Setlist } from '$lib/models/setlist';
	import { formatDuration } from '$lib/util';
	import { notifications } from '$lib';
	import { onMount } from 'svelte';
	import CopyIcon from 'virtual:icons/mdi/content-copy';
	import DeleteIcon from 'virtual:icons/mdi/delete';
	import LoadIcon from 'virtual:icons/mdi/file-upload';
	import EditIcon from 'virtual:icons/mdi/pencil';
	import AddIcon from 'virtual:icons/mdi/plus';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	const sets = data.sets;
	const songs = data.songs;
	const errorMessage = data.error;

	onMount(() => {
		if (errorMessage) {
			notifications.error(`Failed to load data: ${errorMessage}`);
		}
	});

	function formatTitle(item: Setlist) {
		const dateString = `${new Date(item.date).toLocaleDateString()}`;
		const length = item.songs.map((songId) => songs[songId]?.length || 0).reduce((a, b) => a + b, 0);
		const songCount = item.songs.length;
		const songText = songCount > 0 ? ` (${songCount} song${songCount > 1 ? 's' : ''})` : '';
		return `${dateString} - ${item.venue} - ${formatDuration(length)}${songText}`;
	}

	async function handleDeleteClick(item: Setlist) {
		if (!item.id) {
			notifications.error('Cannot delete a set without an ID.');
			return;
		}
		if (confirm('Are you sure you want to delete this set?')) {
			// Update this URL to point to your new external backend
			const result = await fetch(`api/sets/${item.id}`, { method: 'DELETE' });
			if (result.ok) {
				delete sets[item.id];
				notifications.success('Set deleted successfully');
			} else {
				const error = await result.json();
				notifications.error(error.error ? `Failed to delete set: ${error.error}` : 'Failed to delete set');
			}
		}
	}

	async function handleDuplicateClick(item: Setlist) {
		const duplicated: Partial<Setlist> = { ...item, id: undefined, venue: `${item.venue} (copy)` };
		// Update this URL to point to your new external backend
		const result = await fetch('/api/sets', {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify(duplicated)
		});
		if (result.ok) {
			const newSet = await result.json();
			sets[newSet.id] = newSet; // Or sets = [...sets, newSet] with Svelte 5 runes
			notifications.success('Set duplicated successfully');
		} else {
			const error = await result.json();
			notifications.error(error.error ? `Failed to duplicate set: ${error.error}` : 'Failed to duplicate set');
		}
	}

	function sortFunction(a: Setlist, b: Setlist) {
		if (a.date !== b.date) {
			return new Date(b.date).getTime() - new Date(a.date).getTime();
		}
		if (a.venue !== b.venue) {
			return a.venue.localeCompare(b.venue);
		}
		return a.id.localeCompare(b.id);
	}
</script>

<meta:head>
	<title>Sets - Reaper Setlist</title>
</meta:head>

<h1>Sets</h1>

{#if errorMessage}
	<p style="color: red;">{errorMessage}</p>
{:else}
	<ItemGrid items={Object.values(sets).toSorted(sortFunction)} getName={formatTitle}>
		{#snippet actions(item)}
			<Button elementType="a" color="edit" href={`/set/${item.id}/edit`}><EditIcon /></Button>
			<Button color="delete" onclick={() => handleDeleteClick(item)}><DeleteIcon /></Button>
			<Button color="primary" elementType="a" href={`/set/${item.id}/load`}><LoadIcon /></Button>
			<Button color="success" onclick={() => handleDuplicateClick(item)}><CopyIcon /></Button>
		{/snippet}
	</ItemGrid>
{/if}

<Button elementType="a" href="set/add" color="success"><AddIcon /></Button>
