<script lang="ts">
	import type { PageData } from './$types';
	import { goto } from '$app/navigation';
	import { onMount } from 'svelte';
	import { notifications } from '$lib';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';
	import Form from '$lib/components/Form/Form.svelte';
	import Button from '$lib/components/Button/Button.svelte';
	import SaveIcon from 'virtual:icons/mdi/content-save';
	import TestIcon from 'virtual:icons/mdi/check-network';
	import type { ActionIdsRequest } from '$lib/models/action-ids';

	let { data }: { data: PageData } = $props();

	let loadProjectScriptActionId = $state<string | undefined>(data.settings?.loadProjectScriptActionId);
	let listProjectsScriptActionId = $state<string | undefined>(data.settings?.listProjectsScriptActionId);

	onMount(() => {
		// If there's an error (setup incomplete), redirect to setup
		if (data.error) {
			goto('/setup');
		}
	});

	async function testConnection() {
		try {
			const response = await fetch('/api/projects/list', { method: 'GET' });

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
			set_root_script_action_id: setRootActionIdValue ? (setRootActionIdValue as string) : undefined,
			load_project_script_action_id: loadProjectActionIdValue ? (loadProjectActionIdValue as string) : undefined,
			list_projects_script_action_id: listProjectsActionIdValue ? (listProjectsActionIdValue as string) : undefined
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

<Form onsubmit={saveActionIds}>
	<div class="script-config-item">
		<h3>1. Load Project Script</h3>
		<p>This script loads a project from a relative path.</p>
		<a class="download-button" href="/lua/LoadProjectFromRelativePath.lua" download="LoadProjectFromRelativePath.lua">
			Download LoadProjectFromRelativePath.lua
		</a>
		<div class="form-group">
			<label for="load-project-action-id">Action ID:</label>
			<input bind:value={loadProjectScriptActionId} type="text" id="load-project-action-id" name="load-project-action-id" placeholder="e.g., 40002" required />
		</div>
	</div>

	<div class="script-config-item">
		<h3>2. List Projects Script</h3>
		<p>This script lists all available projects in the root folder.</p>
		<a class="download-button" href="/lua/ListProjectFiles.lua" download="ListProjectFiles.lua"> Download ListProjectFiles.lua </a>
		<div class="form-group">
			<label for="list-projects-action-id">Action ID:</label>
			<input
				bind:value={listProjectsScriptActionId}
				type="text"
				id="list-projects-action-id"
				name="list-projects-action-id"
				placeholder="e.g., 40003"
				required
			/>
		</div>
	</div>

	<div class="submit-section">
		<Button elementType="button" color="primary" onclick={testConnection}><TestIcon /> Test Connection</Button>
		<Button elementType="submit" color="success"><SaveIcon /> Save Action IDs</Button>
	</div>
</Form>

<InstructionBox title="Next steps:" steps={nextSteps} variant="success" listType="unordered" />

<style>
	.download-button {
		display: inline-block;
		background-color: var(--primary);
		color: var(--black) !important;
		padding: 0.75rem 1.5rem;
		border-radius: 0.5rem;
		text-decoration: none !important;
		font-weight: 600;
		margin-bottom: 1rem;
		transition: background-color 0.2s ease;
		border: none;
		cursor: pointer;
		font-size: inherit;
	}

	.download-button:hover {
		background-color: hsl(from var(--primary) h s calc(l * 0.9));
		color: var(--black) !important;
	}

	.installation-steps ul {
		margin: 0.5rem 0;
		padding-left: 2rem;
	}

	.installation-steps ol {
		margin: 0;
		padding-left: 2rem;
	}

	.script-config-item {
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
		padding: 1.5rem;
		border: 1px solid var(--current-line);
		border-radius: 0.5rem;
		background-color: hsl(from var(--background) h s calc(l * 1.1));
	}

	.script-config-item h3 {
		margin: 0;
		color: var(--primary);
		font-size: 1.1rem;
	}

	.script-config-item p {
		margin: 0 0 0.5rem 0;
		color: var(--foreground);
		opacity: 0.8;
		font-size: 0.9rem;
	}
</style>
