<script lang="ts">
	import { goto } from '$app/navigation';
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import SetEditor from '$lib/components/SetEditor/SetEditor.svelte';
	import type { Database } from '$lib/models/database';
	import { type NewSetlist } from '$lib/models/setlist';
	import type { Song } from '$lib/models/song';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	let songs = $state<Database<Song>>(data.songs);
	let set = $state<NewSetlist>({
		venue: '',
		date: new Date().toISOString(),
		songs: []
	});
	const errorMessage = data.error;
	const api = getApi();

	async function onSubmit(set: NewSetlist) {
		try {
			await api.sets.add(set);
			notifications.success('Set added successfully!');
			await goto('/');
		} catch (error) {
			notifications.error(`Failed to add set: ${(error as Error).message}`);
		}
	}
</script>

<meta:head>
	<title>Add Set - Reaper Setlist</title>
</meta:head>

<h1>Add Set</h1>

{#if errorMessage}
	<p style="color: red;">{errorMessage}</p>
{:else if Object.keys(songs).length === 0}
	<p>No songs available. Please add some songs first.</p>
{:else}
	<SetEditor setlist={set} {songs} {onSubmit} />
{/if}
