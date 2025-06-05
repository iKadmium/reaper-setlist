<script lang="ts">
	import { notifications } from '$lib';
	import Button from '$lib/components/Button/Button.svelte';
	import Form from '$lib/components/Form/Form.svelte';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';
	import type { ActionIdsRequest } from '$lib/models/action-ids';
	import DownloadIcon from 'virtual:icons/mdi/download';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	let loadProjectScriptActionId = $state<string | undefined>(data.settings?.loadProjectScriptActionId);
	let listProjectsScriptActionId = $state<string | undefined>(data.settings?.listProjectsScriptActionId);

	let loadProjectTestState = $state<'success' | 'error' | null>(null);
	let listProjectsTestState = $state<'success' | 'error' | null>(null);

	function clearLoadProjectTestState() {
		loadProjectTestState = null;
	}
	function clearListProjectsTestState() {
		listProjectsTestState = null;
	}

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

	// Test Load Project Script
	async function testLoadProjectScript() {
		loadProjectTestState = null;
		try {
			const response = await fetch('/api/settings/test-load-project', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ load_project_script_action_id: loadProjectScriptActionId })
			});
			if (response.ok) {
				loadProjectTestState = 'success';
			} else {
				loadProjectTestState = 'error';
				const errorText = await response.text();
				notifications.error(`Load Project Script test failed: ${errorText}`);
			}
		} catch (error) {
			loadProjectTestState = 'error';
			notifications.error('Load Project Script test failed: Network error');
		}
	}

	// Test List Projects Script
	async function testListProjectsScript() {
		listProjectsTestState = null;
		try {
			const response = await fetch('/api/settings/test-list-projects', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ list_projects_script_action_id: listProjectsScriptActionId })
			});
			if (response.ok) {
				listProjectsTestState = 'success';
			} else {
				listProjectsTestState = 'error';
				const errorText = await response.text();
				notifications.error(`List Projects Script test failed: ${errorText}`);
			}
		} catch (error) {
			listProjectsTestState = 'error';
			notifications.error('List Projects Script test failed: Network error');
		}
	}

	const nextSteps = [
		{ label: 'Add your songs', href: '/song' },
		{ label: 'Create setlists', href: '/' }
	];
</script>

<div class="mobile-warning">
	<h2>Mobile Warning</h2>
	<p>
		This will be an annoying and error-prone process if you can't copy and paste these values. It's strongly recommended to perform this step on the same
		computer that runs Reaper.
	</p>
</div>

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
		<a class="download-link" href="/lua/LoadProjectFromRelativePath.lua" download="LoadProjectFromRelativePath.lua">
			<DownloadIcon />
			Download LoadProjectFromRelativePath.lua
		</a>
		<div class="form-group">
			<label for="load-project-action-id">Action ID:</label>
			<div class="input-with-button">
				<input
					bind:value={loadProjectScriptActionId}
					type="text"
					id="load-project-action-id"
					name="load-project-action-id"
					placeholder="e.g., _RS4a7b2c8d9e1f3a5b6c7d8e9f0a1b2c3d4e5f6a7b"
					required
					class:success={loadProjectTestState === 'success'}
					class:error={loadProjectTestState === 'error'}
					oninput={clearLoadProjectTestState}
				/>
				<Button variant="text" elementType="button" onclick={testLoadProjectScript}>Test</Button>
			</div>
		</div>
	</div>

	<div class="script-config-item">
		<h3>2. List Projects Script</h3>
		<p>This script lists all available projects in the root folder.</p>
		<a class="download-link" href="/lua/ListProjectFiles.lua" download="ListProjectFiles.lua">
			<DownloadIcon />
			Download ListProjectFiles.lua
		</a>
		<div class="form-group input-with-test">
			<label for="list-projects-action-id">Action ID:</label>
			<div class="input-with-button">
				<input
					bind:value={listProjectsScriptActionId}
					type="text"
					id="list-projects-action-id"
					name="list-projects-action-id"
					placeholder="e.g., _RS9f8e7d6c5b4a3928176e5d4c3b2a19087f6e5d4c"
					required
					class:success={listProjectsTestState === 'success'}
					class:error={listProjectsTestState === 'error'}
					oninput={clearListProjectsTestState}
				/>
				<Button variant="text" elementType="button" onclick={testListProjectsScript}>Test</Button>
			</div>
		</div>
	</div>

	<div class="submit-section">
		<Button elementType="submit" color="success">Save</Button>
	</div>
</Form>

<InstructionBox title="Next steps:" steps={nextSteps} variant="success" listType="unordered" />

<style>
	.mobile-warning {
		display: none;
		background-color: hsla(from var(--red) h s l / 25%);
		border: 1px solid var(--current-line);
		border-radius: 0.5rem;
		padding: 1rem;
		margin-bottom: 2rem;
	}

	@media (max-width: 768px) {
		.mobile-warning {
			display: block;
		}
	}

	.download-link {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		color: var(--purple);
		text-decoration: none;
		font-weight: 500;
		margin-bottom: 1rem;
		transition: color 0.2s ease;
		font-size: 0.95rem;
	}

	.download-link:hover {
		color: hsl(from var(--purple) h s calc(l * 0.9));
		text-decoration: underline;
	}

	.installation-steps ul {
		margin: 0.5rem 0;
		padding-left: 2rem;
	}

	@media (max-width: 768px) {
		.installation-steps {
			margin-bottom: 2rem;
		}
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

	.input-with-test input {
		flex: 1;
	}
	input.success {
		border-color: var(--green);
		box-shadow: 0 0 0 1px var(--green);
	}
	input.error {
		border-color: var(--red);
		box-shadow: 0 0 0 1px var(--red);
	}
</style>
