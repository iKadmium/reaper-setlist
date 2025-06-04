<script lang="ts">
	import { goto } from '$app/navigation';
	import { notifications } from '$lib';
	import SongEditor from '$lib/components/SongEditor/SongEditor.svelte';
	import { type Song } from '$lib/models/song';
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();

	async function onSubmit(song: Song) {
		const resp = await fetch(`/api/songs/${song.id}`, {
			method: 'PUT',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(song)
		});
		if (resp.ok) {
			notifications.success('Song updated successfully!');
			await goto('/song');
		} else {
			const error = await resp.json();
			notifications.error(`Failed to update song: ${error.error || 'Unknown error'}`);
		}
	}
</script>

<meta:head>
	<title>Edit Song - Reaper Setlist</title>
</meta:head>

<h1>Edit Song</h1>

<SongEditor songs={data.songs} song={data.song} projects={data.projects} {onSubmit} />
