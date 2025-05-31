<script lang="ts">
	import { goto } from '$app/navigation';
	import SetEditor from '$lib/components/SetEditor/SetEditor.svelte';
	import { onMount } from 'svelte';
	import { page } from '$app/state';
	import { isNewSetlist, type NewSetlist, type Setlist } from '$lib/models/setlist';
	import type { Database } from '$lib/models/database';
	import type { Song } from '$lib/models/song';

	let set = $state<Setlist | undefined>(undefined);
	let songs = $state<Database<Song>>({});
	let loading = $state<boolean>(true);

	onMount(async () => {
		try {
			const id = page.params.id;
			const setRes = await fetch(`/api/sets/${id}`);
			if (!setRes.ok) throw new Error('Failed to fetch set');
			set = await setRes.json();
			const songsRes = await fetch('/api/songs');
			if (!songsRes.ok) throw new Error('Failed to fetch songs');
			songs = await songsRes.json();
		} finally {
			loading = false;
		}
	});

	async function onSubmit(set: Setlist) {
		const response = await fetch(`/api/sets/${set.id}`, {
			method: 'PUT',
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
	<title>Edit Set - Reaper Setlist</title>
</meta:head>

<h1>Edit Set</h1>

{#if loading}
	<p>Loading...</p>
{:else if set}
	<SetEditor setlist={set} {songs} {onSubmit} />
{/if}
