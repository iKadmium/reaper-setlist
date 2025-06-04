<script lang="ts">
	import type { PageData } from './$types';
	import { goto } from '$app/navigation';
	import { onMount } from 'svelte';
	import { notifications } from '$lib';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';

	let { data }: { data: PageData } = $props();

	onMount(() => {
		// If there's an error (setup incomplete), redirect to setup
		if (data.error) {
			goto('/setup');
		}
	});

	async function handleClickHereClick() {
		try {
			const response = await fetch('/api/reaper-project/example/load', { method: 'POST' });

			if (response.ok) {
				notifications.success('Reaper project loaded successfully! The shortcut text should now read "/loadproject".');
			} else {
				const errorText = await response.text();
				notifications.error(`Failed to load Reaper project: ${errorText}`);
			}
		} catch (error) {
			notifications.error(`Error loading Reaper project: ${error instanceof Error ? error.message : 'Unknown error'}`);
		}
	}

	const nextSteps = [
		{ label: 'Add your songs', href: '/song' },
		{ label: 'Create setlists', href: '/' }
	];
</script>

<meta:head>
	<title>Installation - Reaper Setlist</title>
</meta:head>

<h1>Installation</h1>

<p>Complete these steps to finish setting up Reaper Setlist:</p>

<ol>
	<li>
		<a class="download-button" href="/api/reaper-script" download="loadproject.lua">Download Script</a>
	</li>
	<li>
		Save this script in your scripts directory. To find this, in Reaper, open the Options menu dropdown and click "Show REAPER resource path in
		explorer/finder". From there, navigate to the "Scripts" directory.
	</li>
	<li>In Reaper, open the Actions window (keyboard shortcut is the question mark "?" key).</li>
	<li>Click "New Action" &gt; "Load ReaScript..." and select the script you saved in step 1.</li>
	<li>In the "Shortcuts for selected action" section, click "Add".</li>
	<li><button class="subtle-button" onclick={handleClickHereClick}>Click here</button>. The shortcut text should now read "/loadproject".</li>
	<li>Click OK.</li>
	<li>Add your songs from the song link in the navbar.</li>
	<li>Add setlists.</li>
	<li>If you need to move the folder path, update it in <a href="/setup" class="setup-link">Setup</a>, save and re-download the script.</li>
</ol>

<InstructionBox title="Next steps:" steps={nextSteps} variant="success" listType="unordered" />

<style>
	.subtle-button {
		background-color: unset;
		border: none;
		color: var(--foreground);
		cursor: pointer;
		font-size: inherit;
		padding: 0;
		text-decoration: underline;
	}

	.setup-link {
		color: var(--primary) !important;
		font-weight: 600;
		text-decoration: none !important;
	}

	.setup-link:hover {
		color: var(--primary) !important;
		text-decoration: none !important;
	}

	.download-button {
		display: inline-block;
		background-color: var(--primary);
		color: var(--black) !important;
		padding: 0.75rem 1.5rem;
		border-radius: 0.5rem;
		text-decoration: none !important;
		font-weight: 600;
		margin-bottom: 0.5rem;
		transition: background-color 0.2s ease;
	}

	.download-button:hover {
		background-color: var(--primary);
		color: white !important;
	}
</style>
