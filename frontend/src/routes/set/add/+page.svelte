<script lang="ts">
	import { goto } from '$app/navigation';
	import SetEditor from '$lib/components/SetEditor/SetEditor.svelte';
	import { type SetlistDenormalized } from '$lib/server/db/schema';
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();

	let set: SetlistDenormalized = {
		venue: '',
		date: new Date().getTime(),
		songs: []
	};

	async function onSubmit(set: SetlistDenormalized) {
		const response = await fetch('/api/set', {
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

<SetEditor setlist={set} songs={data.songs} {onSubmit} />
