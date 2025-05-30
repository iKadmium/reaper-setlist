<script lang="ts">
	import { goto } from '$app/navigation';
	import { page } from '$app/state';
	import SongEditor from '$lib/components/SongEditor/SongEditor.svelte';
	import type { Song } from '$lib/models/song';
	import { onMount } from 'svelte';

	let song = $state<Song | undefined>(undefined);
	let loading = $state<boolean>(true);

	onMount(async () => {
		try {
			const id = page.params.id;
			const res = await fetch(`/api/songs/${id}`);
			if (!res.ok) throw new Error('Failed to fetch song');
			song = await res.json();
		} finally {
			loading = false;
		}
	});

	async function onSubmit(song: Song) {
		const resp = await fetch(`/api/songs/${song.id}`, {
			method: 'PUT',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(song)
		});
		if (resp.ok) {
			await goto(`/song/${song.id}`);
		} else {
			const error = await resp.json();
			alert(`Failed to update song: ${error.error || 'Unknown error'}`);
		}
	}
</script>

<meta:head>
	<title>Edit Song - Reaper Setlist</title>
</meta:head>

<h1>Edit Song</h1>

{#if loading}
	<p>Loading...</p>
{:else if song}
	<SongEditor {song} {onSubmit} />
{/if}
