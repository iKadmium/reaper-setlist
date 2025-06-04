<script lang="ts">
	import { goto } from '$app/navigation';
	import SetEditor from '$lib/components/SetEditor/SetEditor.svelte';
	import { notifications } from '$lib';
	import type { Database } from '$lib/models/database';
	import { isNewSetlist, type NewSetlist, type Setlist } from '$lib/models/setlist';
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

	async function onSubmit(set: NewSetlist) {
		const response = await fetch('/api/sets', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(set)
		});
		if (response.ok) {
			notifications.success('Set added successfully!');
			await goto('/');
		} else {
			const error = await response.json();
			notifications.error(error.error ? `Failed to add set: ${error.error}` : 'Failed to add set');
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
