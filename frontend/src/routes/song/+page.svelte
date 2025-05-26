<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import ItemGrid from '$lib/components/ItemGrid/ItemGrid.svelte';
	import type { Song } from '$lib/server/db/schema';
	import type { PageProps } from './$types';

	import DeleteIcon from 'virtual:icons/mdi/delete';
	import EditIcon from 'virtual:icons/mdi/pencil';
	import PlayIcon from 'virtual:icons/mdi/play';
	import AddIcon from 'virtual:icons/mdi/plus';

	let { data }: PageProps = $props();
	let songs = $state(data.songs);

	async function handleLoadClick(song: Song) {
		const newTabResult = await fetch(`/api/reaper-project/new-tab`, { method: 'POST' });
		await newTabResult.json(); // wait for the operation to complete
		const songLoadResult = await fetch(`/api/reaper-project/${song.name}/load`, { method: 'POST' });
		await songLoadResult.json(); // wait for the operation to complete
	}

	async function handleDeleteClick(song: Song) {
		if (confirm('Are you sure you want to delete this song?')) {
			const result = await fetch(`/api/song/${song.id}`, { method: 'DELETE' });
			if (result.ok) {
				data.songs.splice(data.songs.indexOf(song), 1);
			} else {
				const error = await result.json();
				error.error ? alert(`Failed to delete song: ${error.error}`) : 'Failed to delete song.';
			}
		}
	}
</script>

<meta:head>
	<title>Songs - Reaper Setlist</title>
</meta:head>

<h1>Songs</h1>

<ItemGrid items={songs} getName={(song) => song.name}>
	{#snippet actions(item)}
		<Button elementType="a" color="edit" href={`/song/${item.id}/edit`}><EditIcon /></Button>
		<Button color="delete" onclick={() => handleDeleteClick(item)}><DeleteIcon /></Button>
		<Button color="primary" elementType="a" href={`/set/${item.id}/load`}><PlayIcon /></Button>
	{/snippet}
</ItemGrid>

<Button elementType="a" href="song/add" color="success"><AddIcon /></Button>
