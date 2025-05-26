<script lang="ts">
	import { goto } from '$app/navigation';
	import SongEditor from '$lib/components/SongEditor/SongEditor.svelte';
	import type { Song, SongInsert } from '$lib/server/db/schema';
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();

	async function onSubmit(song: Song | SongInsert) {
		await fetch(`/api/song/${song.id}`, {
			method: 'PUT',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(song)
		});
		await goto('/song');
	}
</script>

<meta:head>
	<title>Edit Song - Reaper Setlist</title>
</meta:head>

<h1>Edit Song</h1>

<SongEditor song={data.song} {onSubmit} />
