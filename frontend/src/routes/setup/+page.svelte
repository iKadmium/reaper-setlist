<script lang="ts">
	import { goto } from '$app/navigation';
	import { base } from '$app/paths';
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import Button from '$lib/components/Button/Button.svelte';
	import Form from '$lib/components/Form/Form.svelte';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';
	import type { PageProps } from './$types';
	import DownloadIcon from 'virtual:icons/mdi/download';

	let { data }: PageProps = $props();

	const api = getApi();

	let folderPath = $state<string | undefined>(data.folderPath);
	let scriptActionId = $state<string | undefined>(data.scriptActionId);
	let scriptTestState = $state<'success' | 'error' | null>(null);

	const nextSteps = [
		{ label: 'Add your songs', href: '/song' },
		{ label: 'Create setlists', href: '/' }
	];

	const setupSteps = [
		{ label: 'Download the Reaper Setlist script from the link below.' },
		{ label: 'Open Reaper and go to "Actions" > "Show Action List".' },
		{ label: 'Click "New Action" -> "Load ReaScript" and select the downloaded script file.' },
		{ label: 'Copy the Action ID of the script from the Action List.' },
		{ label: 'Click "Test" to ensure the script is working correctly.' },

		{ label: 'Enter the root folder path where your backing tracks are stored in the form below.' },
		{ label: 'Click "Save" to store these settings.' }
	];

	async function handleSubmit(event: Event) {
		event.preventDefault();
		const formData = new FormData(event.target as HTMLFormElement);
		const folderPathValue = formData.get('backing-tracks-folder') || '';

		try {
			await api.scriptSettings.setProjectRoot(folderPathValue as string);
			notifications.success('Settings saved successfully!');
		} catch (error) {
			notifications.error(`Failed to set folder path: ${(error as Error).message}`);
			return;
		}
	}

	function clearScriptTestState() {
		scriptTestState = null;
	}

	// Test Script
	async function testScript() {
		scriptTestState = null;
		try {
			const success = await api.script.testActionId(scriptActionId as string);

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
</script>

<div class="content">
	<h1>Setup</h1>

	<InstructionBox title="Setup Steps" steps={setupSteps} variant="help" listType="ordered" />

	<Form onsubmit={handleSubmit}>
		<h3>Script</h3>
		<a class="download-link" href={`${base}/lua/reaper-setlist.lua`} download="reaper-setlist.lua">
			<DownloadIcon />
			Download reaper-setlist.lua
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

		<div class="form-group">
			<label for="backing-tracks-folder">Backing Tracks Root Folder:</label>
			<input bind:value={folderPath} type="text" id="backing-tracks-folder" name="backing-tracks-folder" placeholder="e.g., /path/to/your/backing/tracks" />
		</div>

		<div class="submit-section">
			<Button elementType="submit" color="success">Save</Button>
		</div>
	</Form>
</div>

<div class="mobile-warning">
	<h2>Mobile Warning</h2>
	<p>
		This will be an annoying and error-prone process if you can't copy and paste these values. It's strongly recommended to perform this step on the same
		computer that runs Reaper.
	</p>
</div>

<InstructionBox title="Next steps:" steps={nextSteps} variant="success" listType="unordered" />

<style>
	.content {
		max-width: 800px;
		margin: 0 auto;
		padding: 2rem;
	}

	@media (max-width: 768px) {
		.content {
			padding: 1rem;
		}
	}

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
</style>
