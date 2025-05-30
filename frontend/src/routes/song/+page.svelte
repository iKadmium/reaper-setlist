<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import ItemGrid from '$lib/components/ItemGrid/ItemGrid.svelte';
	import type { Database } from '$lib/models/database';
	import type { Song } from '$lib/models/song';
	import { onMount } from 'svelte';

	import DeleteIcon from 'virtual:icons/mdi/delete';
	import EditIcon from 'virtual:icons/mdi/pencil';
	import PlayIcon from 'virtual:icons/mdi/play';
	import AddIcon from 'virtual:icons/mdi/plus';

	let songs = $state<Database<Song>>({});
	let loading = $state<boolean>(true);
	let error = $state<string | null>(null);

	onMount(async () => {
		try {
			const res = await fetch('/api/songs');
			if (!res.ok) throw new Error('Failed to fetch songs');
			songs = await res.json();
		} catch (e) {
			error = e instanceof Error ? e.message : 'Unknown error';
		} finally {
			loading = false;
		}
	});

	async function handleLoadClick(song: Song) {
		const newTabResult = await fetch(`/api/reaper-project/new-tab`, { method: 'POST' });
		await newTabResult.json(); // wait for the operation to complete
		const songLoadResult = await fetch(`/api/reaper-project/${song.name}/load`, { method: 'POST' });
		await songLoadResult.json(); // wait for the operation to complete
	}

	async function handleDeleteClick(song: Song) {
		if (confirm('Are you sure you want to delete this song?')) {
			const result = await fetch(`/api/songs/${song.id}`, { method: 'DELETE' });
			if (result.ok) {
				delete songs[song.id];
			} else {
				const error = await result.json();
				error.error ? alert(`Failed to delete song: ${error.error}`) : alert('Failed to delete song.');
			}
		}
	}

	function sortFunction(a: Song, b: Song) {
		return a.name.localeCompare(b.name);
	}

	function getName(song: Song) {
		const displayString = `${song.name} (${song.length})`;
		return displayString;
	}
</script>

<meta:head>
	<title>Songs - Reaper Setlist</title>
</meta:head>

<h1>Songs</h1>

<ItemGrid items={Object.values(songs).toSorted(sortFunction)} {getName}>
	{#snippet actions(item)}
		<Button elementType="a" color="edit" href={`/song/${item.name}/edit`}><EditIcon /></Button>
		<Button color="delete" onclick={() => handleDeleteClick(item)}><DeleteIcon /></Button>
		<Button color="primary" onclick={() => handleLoadClick(item)}><PlayIcon /></Button>
	{/snippet}
</ItemGrid>

<Button elementType="a" href="song/add" color="success"><AddIcon /></Button>
