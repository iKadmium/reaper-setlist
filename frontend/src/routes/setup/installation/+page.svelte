<script lang="ts">
	import type { PageData } from './$types';
	import { goto } from '$app/navigation';
	import { onMount } from 'svelte';
	import { notifications } from '$lib';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';
	import Button from '$lib/components/Button/Button.svelte';
	import SaveIcon from 'virtual:icons/mdi/content-save';
	import TestIcon from 'virtual:icons/mdi/check-network';
	import type { ActionIdsRequest } from '$lib/models/action-ids';

	let { data }: { data: PageData } = $props();

	let setRootScriptActionId = $state<number | undefined>(data.settings?.setRootScriptActionId);
	let loadProjectScriptActionId = $state<number | undefined>(data.settings?.loadProjectScriptActionId);
	let listProjectsScriptActionId = $state<number | undefined>(data.settings?.listProjectsScriptActionId);

	onMount(() => {
		// If there's an error (setup incomplete), redirect to setup
		if (data.error) {
			goto('/setup');
		}
	});

	async function testConnection() {
		try {
			const response = await fetch('/api/projects/set-root', { method: 'POST' });

			if (response.ok) {
				notifications.success('Successfully connected to Reaper and set project root!');
			} else {
				const errorText = await response.text();
				notifications.error(`Failed to set project root: ${errorText}`);
			}
		} catch (error) {
			notifications.error(`Error connecting to Reaper: ${error instanceof Error ? error.message : 'Unknown error'}`);
		}
	}
	async function saveActionIds(event: Event) {
		event.preventDefault();
		const formData = new FormData(event.target as HTMLFormElement);
		const setRootActionIdValue = formData.get('set-root-action-id');
		const loadProjectActionIdValue = formData.get('load-project-action-id');
		const listProjectsActionIdValue = formData.get('list-projects-action-id');

		const body: ActionIdsRequest = {
			set_root_script_action_id: setRootActionIdValue ? parseInt(setRootActionIdValue as string) : undefined,
			load_project_script_action_id: loadProjectActionIdValue ? parseInt(loadProjectActionIdValue as string) : undefined,
			list_projects_script_action_id: listProjectsActionIdValue ? parseInt(listProjectsActionIdValue as string) : undefined
		};

		try {
			const response = await fetch('/api/settings/action-ids', {
				method: 'PUT',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify(body)
			});

			if (response.ok) {
				notifications.success('Action IDs saved successfully!');
			} else {
				notifications.error('Failed to save action IDs');
			}
		} catch (error) {
			notifications.error('Error saving action IDs');
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

<div class="installation-steps">
	<ol>
		<li>
			Save the scripts (downloaded below) in your Reaper scripts directory. To find this, in Reaper, open the Options menu dropdown and click "Show REAPER
			resource path in explorer/finder". From there, navigate to the "Scripts" directory.
		</li>
		<li>In Reaper, open the Actions window (keyboard shortcut is the question mark "?" key).</li>
		<li>
			For each script:
			<ul>
				<li>Click "New Action" &gt; "Load ReaScript..." and select the script.</li>
				<li>Right click the script that's now been added to the action list and select Copy Action ID.</li>
				<li>Enter the command ID in the corresponding field below.</li>
			</ul>
		</li>
		<li>Test the connection using the button at the bottom.</li>
	</ol>
</div>

<div class="action-ids-section">
	<h2>Download Scripts & Configure Action IDs</h2>
	<p>Download each script, install it in Reaper, and enter its assigned command ID:</p>

	<form onsubmit={saveActionIds}>
		<div class="script-config-item">
			<h3>1. Set Project Root Folder Script</h3>
			<p>This script sets the root folder for your projects.</p>
			<a class="download-button" href="/api/reaper-script/SetProjectRootFolder.lua" download="SetProjectRootFolder.lua"> Download SetProjectRootFolder.lua </a>
			<label for="set-root-action-id">Action ID:</label>
			<input bind:value={setRootScriptActionId} type="number" id="set-root-action-id" name="set-root-action-id" placeholder="e.g., 40001" required />
		</div>

		<div class="script-config-item">
			<h3>2. Load Project Script</h3>
			<p>This script loads a project from a relative path.</p>
			<a class="download-button" href="/api/reaper-script/LoadProjectFromRelativePath.lua" download="LoadProjectFromRelativePath.lua">
				Download LoadProjectFromRelativePath.lua
			</a>
			<label for="load-project-action-id">Action ID:</label>
			<input
				bind:value={loadProjectScriptActionId}
				type="number"
				id="load-project-action-id"
				name="load-project-action-id"
				placeholder="e.g., 40002"
				required
			/>
		</div>

		<div class="script-config-item">
			<h3>3. List Projects Script</h3>
			<p>This script lists all available projects in the root folder.</p>
			<a class="download-button" href="/api/reaper-script/ListProjectFiles.lua" download="ListProjectFiles.lua"> Download ListProjectFiles.lua </a>
			<label for="list-projects-action-id">Action ID:</label>
			<input
				bind:value={listProjectsScriptActionId}
				type="number"
				id="list-projects-action-id"
				name="list-projects-action-id"
				placeholder="e.g., 40003"
				required
			/>
		</div>

		<div class="action-buttons">
			<Button elementType="button" color="primary" onclick={testConnection}><TestIcon /> Test Connection</Button>
			<Button elementType="submit" color="success"><SaveIcon /> Save Action IDs</Button>
		</div>
	</form>
</div>

<InstructionBox title="Next steps:" steps={nextSteps} variant="success" listType="unordered" />

<style>
	.action-buttons {
		display: flex;
		gap: 1rem;
		margin-top: 1rem;
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
		border: none;
		cursor: pointer;
		font-size: inherit;
	}

	.download-button:hover {
		background-color: var(--primary);
		color: white !important;
	}

	.installation-steps ul {
		margin: 0.5rem 0;
		padding-left: 2rem;
	}

	.action-ids-section {
		margin: 2rem 0;
		padding: 1.5rem;
		border: 2px solid var(--primary);
		border-radius: 0.5rem;
		background-color: var(--background);
		box-sizing: border-box;
		width: 100%;
	}

	.action-ids-section h2 {
		margin-top: 0;
		color: var(--primary);
	}

	.action-ids-section form {
		display: flex;
		flex-direction: column;
		gap: 2rem;
	}

	.script-config-item {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		padding: 1.5rem;
		border: 1px solid var(--border);
		border-radius: 0.5rem;
		background-color: var(--background-secondary, var(--background));
	}

	.script-config-item h3 {
		margin-top: 0;
		margin-bottom: 0.5rem;
		color: var(--primary);
	}

	.script-config-item p {
		margin: 0 0 1rem 0;
		color: var(--text-secondary);
	}

	.action-ids-section label {
		font-weight: 600;
		color: var(--text-primary);
		margin-top: 1rem;
	}

	.action-ids-section input {
		padding: 0.5rem;
		border: 1px solid var(--border);
		border-radius: 0.25rem;
		font-size: 1rem;
		margin-top: 0.25rem;
	}

	.action-ids-section form > :global(button) {
		margin-top: 1rem;
		align-self: flex-start;
	}
</style>
