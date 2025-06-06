<script lang="ts">
	import { notifications } from '$lib';
	import Button from '$lib/components/Button/Button.svelte';
	import Form from '$lib/components/Form/Form.svelte';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';
	import type { ActionIdsRequest } from '$lib/models/action-ids';
	import DownloadIcon from 'virtual:icons/mdi/download';
	import type { PageData } from './$types';
	import { getApi } from '$lib/api/api';

	let { data }: { data: PageData } = $props();

	const api = getApi();

	let scriptActionId = $state<string | undefined>(data.scriptActionId);
	let scriptTestState = $state<'success' | 'error' | null>(null);

	function clearScriptTestState() {
		scriptTestState = null;
	}

	async function saveActionId(event: Event) {
		event.preventDefault();
		const formData = new FormData(event.target as HTMLFormElement);
		const loadProjectActionIdValue = formData.get('script-action-id');

		try {
			await api.settings.setScriptActionId(loadProjectActionIdValue as string);
			notifications.success('Action IDs saved successfully!');
		} catch (error) {
			notifications.error('Failed to save action IDs');
		}
	}

	// Test Script
	async function testScript() {
		scriptTestState = null;
		try {
			const success = await api.reaper.testActionId(scriptActionId as string);

			if (success) {
				scriptTestState = 'success';
			} else {
				scriptTestState = 'error';
				notifications.error(`Load Project Script test failed`);
			}
		} catch (error) {
			scriptTestState = 'error';
			notifications.error(`Load Project Script test failed: ${(error as Error).message}`);
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

<Form onsubmit={saveActionId}>
	<div class="script-config-item">
		<h3>Script</h3>
		<p>This script loads a project from a relative path.</p>
		<a class="download-link" href="/lua/LoadProjectFromRelativePath.lua" download="LoadProjectFromRelativePath.lua">
			<DownloadIcon />
			Download LoadProjectFromRelativePath.lua
		</a>
		<div class="form-group">
			<label for="script-action-id">Action ID:</label>
			<div class="input-with-button">
				<input
					bind:value={scriptActionId}
					type="text"
					id="script-action-id"
					name="script-action-id"
					placeholder="e.g., _RS4a7b2c8d9e1f3a5b6c7d8e9f0a1b2c3d4e5f6a7b"
					required
					class:success={scriptTestState === 'success'}
					class:error={scriptTestState === 'error'}
					oninput={clearScriptTestState}
				/>
				<Button variant="text" elementType="button" onclick={testScript}>Test</Button>
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
</style>
