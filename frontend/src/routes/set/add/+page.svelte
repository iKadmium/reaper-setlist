<script lang="ts">
	import { goto } from '$app/navigation';
	import SetEditor from '$lib/components/SetEditor/SetEditor.svelte';
	import type { Database } from '$lib/models/database';
	import { isNewSetlist, type NewSetlist, type Setlist } from '$lib/models/setlist';
	import type { Song } from '$lib/models/song';
	import { onMount } from 'svelte';

	let songs = $state<Database<Song>>({});
	let set = $state<NewSetlist>({
		venue: '',
		date: new Date().toISOString(),
		songs: []
	});
	let loading = $state<boolean>(true);

	onMount(async () => {
		try {
			const res = await fetch('/api/songs');
			if (!res.ok) throw new Error('Failed to fetch songs');
			songs = await res.json();
		} finally {
			loading = false;
		}
	});

	async function onSubmit(set: NewSetlist) {
		const response = await fetch('/api/sets', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(set)
		});
		if (response.ok) {
			await goto('/');
		}
	}
</script>

<meta:head>
	<title>Add Set - Reaper Setlist</title>
</meta:head>

<h1>Add Set</h1>

{#if loading}
	<p>Loading songs...</p>
{:else if Object.keys(songs).length === 0}
	<p>No songs available. Please add some songs first.</p>
{:else}
	<SetEditor setlist={set} {songs} {onSubmit} />
{/if}
