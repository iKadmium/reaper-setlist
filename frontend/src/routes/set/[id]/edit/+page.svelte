<script lang="ts">
	import { goto } from '$app/navigation';
	import { base } from '$app/paths';
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import SetEditor from '$lib/components/SetEditor/SetEditor.svelte';
	import type { Database } from '$lib/models/database';
	import { type Setlist } from '$lib/models/setlist';
	import type { Song } from '$lib/models/song';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	let set = $state<Setlist | undefined>(data.set);
	let songs = $state<Database<Song>>(data.songs);
	const errorMessage = data.error;
	const api = getApi();

	async function onSubmit(set: Setlist) {
		try {
			await api.sets.update(set.id, set);
			await goto(`${base}/#/`);
		} catch (error) {
			notifications.error(`Failed to update set: ${(error as Error).message}`);
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
