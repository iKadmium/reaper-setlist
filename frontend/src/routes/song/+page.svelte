<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import ItemGrid from '$lib/components/ItemGrid/ItemGrid.svelte';
	import type { Database } from '$lib/models/database';
	import type { Song } from '$lib/models/song';
	import { formatDuration } from '$lib/util';
	import { notifications } from '$lib';
	import type { PageData } from './$types';

	import DeleteIcon from 'virtual:icons/mdi/delete';
	import EditIcon from 'virtual:icons/mdi/pencil';
	import PlayIcon from 'virtual:icons/mdi/play';
	import AddIcon from 'virtual:icons/mdi/plus';

	let { data }: { data: PageData } = $props();

	let songs = $state<Database<Song>>(data.songs);
	const errorMessage = data.error;

	async function handleLoadClick(song: Song) {
		try {
			const newTabResult = await fetch(`/api/reaper-project/new-tab`, { method: 'POST' });
			if (!newTabResult.ok) {
				notifications.error('Failed to create new tab in Reaper');
				return;
			}
			await newTabResult.json(); // wait for the operation to complete

			const songLoadResult = await fetch(`/api/songs/load`, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({ relative_path: song.relativePath })
			});
			if (!songLoadResult.ok) {
				notifications.error(`Failed to load ${song.name} in Reaper`);
				return;
			}
			await songLoadResult.json(); // wait for the operation to complete
			notifications.success(`${song.name} loaded successfully in Reaper!`);
		} catch (error) {
			notifications.error('Failed to communicate with Reaper');
		}
	}

	async function handleDeleteClick(song: Song) {
		if (confirm('Are you sure you want to delete this song?')) {
			const result = await fetch(`/api/songs/${song.id}`, { method: 'DELETE' });
			if (result.ok) {
				delete songs[song.id];
				notifications.success('Song deleted successfully');
			} else {
				const error = await result.json();
				notifications.error(error.error ? `Failed to delete song: ${error.error}` : 'Failed to delete song');
			}
		}
	}

	function sortFunction(a: Song, b: Song) {
		return a.name.localeCompare(b.name);
	}

	function getName(song: Song) {
		const displayLength = formatDuration(song.length);
		const displayString = `${song.name} (${displayLength}) - ${song.relativePath}`;
		return displayString;
	}
</script>

<meta:head>
	<title>Songs - Reaper Setlist</title>
</meta:head>

<h1>Songs</h1>

{#if errorMessage}
	<p style="color: red;">{errorMessage}</p>
{:else}
	<ItemGrid items={Object.values(songs).toSorted(sortFunction)} {getName}>
		{#snippet actions(item: Song)}
			<Button elementType="a" color="edit" href={`/song/${item.id}/edit`}><EditIcon /></Button>
			<Button color="delete" onclick={() => handleDeleteClick(item)}><DeleteIcon /></Button>
			<Button color="primary" onclick={() => handleLoadClick(item)}><PlayIcon /></Button>
		{/snippet}
	</ItemGrid>
{/if}

<Button elementType="a" href="song/add" color="success"><AddIcon /></Button>
