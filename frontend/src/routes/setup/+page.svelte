<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';

	import SaveIcon from 'virtual:icons/mdi/content-save';
	import type { PageProps } from './$types';

	let { data, form }: PageProps = $props();

	async function handleClickHereClick() {
		await fetch('/api/reaper-project/example/load', { method: 'POST' });
	}
</script>

<meta:head>
	<title>Setup - Reaper Setlist</title>
</meta:head>

<h1>Setup</h1>

<form method="post">
	<div>
		<label for="backing-tracks-folder">Backing Tracks Root Folder:</label>
		<input value={data.folderPath} type="text" id="backing-tracks-folder" name="backing-tracks-folder" placeholder="Enter folder path" />
	</div>

	<div>
		<label for="reaper-url">Reaper URL:</label>
		<input value={data.reaperUrl} type="text" id="reaper-url" name="reaper-url" placeholder="Enter Reaper URL" />
	</div>

	<Button elementType="submit" color="primary"><SaveIcon /></Button>
	{#if !form?.success && form?.message}
		<p>{form.message}</p>
	{/if}
</form>

<h2>Instructions</h2>
<ol>
	{#if !data.folderPath || !data.reaperUrl}
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
