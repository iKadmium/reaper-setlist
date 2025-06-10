<script lang="ts">
	import { goto } from '$app/navigation';
	import { base } from '$app/paths';
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import SongEditor from '$lib/components/SongEditor/SongEditor.svelte';
	import { type Song } from '$lib/models/song';
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();
	const api = getApi();

	async function onSubmit(song: Song) {
		try {
			await api.songs.update(song.id, song);
			notifications.success('Song updated successfully!');
			await goto(`${base}/#/song`);
		} catch (error) {
			notifications.error(`Failed to update song: ${(error as Error).message}`);
			return;
		}
	}
</script>

<meta:head>
	<title>Edit Song - Reaper Setlist</title>
</meta:head>

<h1>Edit Song</h1>

<SongEditor songs={data.songs} song={data.song} projects={data.projects} {onSubmit} />
