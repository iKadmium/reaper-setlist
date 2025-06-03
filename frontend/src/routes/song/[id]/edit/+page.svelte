<script lang="ts">
	import { goto } from '$app/navigation';
	import SongEditor from '$lib/components/SongEditor/SongEditor.svelte';
	import { isNewSong, type NewSong, type Song } from '$lib/models/song';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	let song = $state<Song | undefined>(data.song);
	const errorMessage = data.error;

	async function onSubmit(song: Song) {
		const resp = await fetch(`/api/songs/${song.id}`, {
			method: 'PUT',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(song)
		});
		if (resp.ok) {
			await goto('/song');
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

{#if errorMessage}
	<p style="color: red;">{errorMessage}</p>
{:else if song}
	<SongEditor {song} {onSubmit} />
{:else}
	<p>Song not found.</p>
{/if}
