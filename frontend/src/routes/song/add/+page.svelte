<script lang="ts">
	import { goto } from '$app/navigation';
	import SongEditor from '$lib/components/SongEditor/SongEditor.svelte';
	import type { Song } from '$lib/models/song';
	let song: Song = {
		id: crypto.randomUUID(),
		length: 0,
		name: ''
	};

	async function onSubmit(song: Song) {
		const resp = await fetch('/api/songs', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(song)
		});
		if (resp.ok) {
			await goto('/song');
		}
	}
</script>

<meta:head>
	<title>Add Song - Reaper Setlist</title>
</meta:head>

<h1>Add Song</h1>

<SongEditor {song} {onSubmit} />
