<script lang="ts">
	import { goto } from '$app/navigation';
	import SetEditor from '$lib/components/SetEditor/SetEditor.svelte';
	import { type SetlistDenormalized } from '$lib/server/db/schema';
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();

	async function onSubmit(setlist: SetlistDenormalized) {
		const response = await fetch(`/api/set/${data.set.id}`, {
			method: 'PUT',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(setlist)
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

<SetEditor setlist={data.set} songs={data.songs} {onSubmit} />
