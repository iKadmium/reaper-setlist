<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import SaveIcon from 'virtual:icons/mdi/content-save';
	import { onMount } from 'svelte';

	let folderPath = $state<string>('');
	let reaperUrl = $state<string>('');
	let form = $state<{ success?: boolean; message?: string }>({});
	let loading = $state<boolean>(true);

	onMount(async () => {
		try {
			const res = await fetch('/api/settings');
			if (!res.ok) throw new Error('Failed to fetch settings');
			const settings = await res.json();
			folderPath = settings.folderPath;
			reaperUrl = settings.reaperUrl;
		} catch (e) {
			form.message = e instanceof Error ? e.message : 'Unknown error';
		} finally {
			loading = false;
		}
	});

	async function handleSubmit(event: Event) {
		event.preventDefault();
		const formData = new FormData(event.target as HTMLFormElement);
		const reaperUrlValue = formData.get('reaper-url');
		const folderPathValue = formData.get('backing-tracks-folder');
		const res = await fetch('/api/settings', {
			method: 'PUT',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ reaperUrl: reaperUrlValue, folderPath: folderPathValue })
		});
		if (!res.ok) {
			form.message = 'Failed to save settings';
			return;
		} else {
			form.success = true;
			form.message = 'Settings saved successfully';
		}
	}

	async function handleClickHereClick() {
		await fetch('/api/reaper-project/example/load', { method: 'POST' });
	}
</script>

<meta:head>
	<title>Setup - Reaper Setlist</title>
</meta:head>

<h1>Setup</h1>

<form onsubmit={handleSubmit}>
	<div>
		<label for="backing-tracks-folder">Backing Tracks Root Folder:</label>
		<input bind:value={folderPath} type="text" id="backing-tracks-folder" name="backing-tracks-folder" placeholder="Enter folder path" />
	</div>

	<div>
		<label for="reaper-url">Reaper URL:</label>
		<input bind:value={reaperUrl} type="text" id="reaper-url" name="reaper-url" placeholder="Enter Reaper URL" />
	</div>

	<Button elementType="submit" color="primary"><SaveIcon /></Button>
	{#if !form?.success && form?.message}
		<p>{form.message}</p>
	{/if}
</form>

<h2>Instructions</h2>
<ol>
	{#if !folderPath || !reaperUrl}
		<li>In Reaper, under preferences &gt; Control/OSC/Web, add a web browser interface if you haven't already.</li>
		<li>Enter the root folder path where your backing tracks are stored and the Access URL from the web browser interface in the form above. Click "Save".</li>
	{:else}
		<li>
			Save <a class="subtle-button" href="/api/reaper-script" download="loadproject.lua">this script</a> with a reasonable name in your scripts directory. To find
			this, in Reaper, open the Options menu dropdown and click "Show REAPER resource path in explorer/finder". From there, navigate to the "Scripts" directory.
		</li>
		<li>In Reaper, open the Actions window (keyboard shortcut is the question mark "?" key).</li>
		<li>Click "New Action" &gt; "Load ReaScript..." and select the script you saved in step 2.</li>
		<li>In the "Shortcuts for selected action" section, click "Add".</li>
		<li><button class="subtle-button" onclick={handleClickHereClick}>Click here</button>. The shortcut text should now read "/loadproject".</li>
		<li>Click OK.</li>
		<li>Add your songs from the song link in the navbar.</li>
		<li>Add setlists.</li>
		<li>If you need to move the folder path, update it above, save and re-download the script.</li>
	{/if}
</ol>

<style>
	form {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		align-items: flex-start;
	}

	.subtle-button {
		background-color: unset;
		border: none;
		color: var(--foreground);
		cursor: pointer;
		font-size: inherit;
		padding: 0;
		text-decoration: underline;
	}
</style>
