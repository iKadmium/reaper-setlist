<script lang="ts">
	import { goto } from '$app/navigation';
	import SongEditor from '$lib/components/SongEditor/SongEditor.svelte';
	import { type SongInsert } from '$lib/server/db/schema';
	let song: SongInsert = {
		length: 0,
		name: ''
	};

	async function onSubmit(song: SongInsert) {
		await fetch('/api/song', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(song)
		});
		await goto('/song');
	}
</script>

<meta:head>
	<title>Add Song - Reaper Setlist</title>
</meta:head>

<h1>Add Song</h1>

<SongEditor {song} {onSubmit} />
