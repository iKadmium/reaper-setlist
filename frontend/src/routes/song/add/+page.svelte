<script lang="ts">
	import { goto } from '$app/navigation';
	import { base } from '$app/paths';
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import SongEditor from '$lib/components/SongEditor/SongEditor.svelte';
	import { type NewSong } from '$lib/models/song';
	import type { PageProps } from './$types';
	let song: NewSong = {
		length: 0,
		name: '',
		path: ''
	};

	let { data }: PageProps = $props();
	const api = getApi();

	async function onSubmit(song: NewSong) {
		try {
			await api.songs.add(song);
			notifications.success('Song added successfully!');
		} catch (error) {
			notifications.error(`Failed to add song: ${(error as Error).message}`);
			return;
		}

		await goto(`${base}/#/song`);
	}
</script>

<meta:head>
	<title>Add Song - Reaper Setlist</title>
</meta:head>

<h1>Add Song</h1>

<SongEditor {song} songs={data.songs} projects={data.projects} {onSubmit} />
