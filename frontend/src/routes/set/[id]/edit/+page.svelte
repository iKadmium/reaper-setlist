<script lang="ts">
	import { goto } from '$app/navigation';
	import SetEditor from '$lib/components/SetEditor/SetEditor.svelte';
	import { isNewSetlist, type NewSetlist, type Setlist } from '$lib/models/setlist';
	import type { Database } from '$lib/models/database';
	import type { Song } from '$lib/models/song';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	let set = $state<Setlist | undefined>(data.set);
	let songs = $state<Database<Song>>(data.songs);
	const errorMessage = data.error;

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

{#if errorMessage}
	<p style="color: red;">{errorMessage}</p>
{:else if set}
	<SetEditor setlist={set} {songs} {onSubmit} />
{:else}
	<p>Set not found.</p>
{/if}
