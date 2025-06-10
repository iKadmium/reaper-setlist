<script lang="ts">
	import { base } from '$app/paths';
	import { configuration, notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import Button from '$lib/components/Button/Button.svelte';
	import Form from '$lib/components/Form/Form.svelte';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';
	import type { StepStatus } from '$lib/components/Step/Step.svelte';
	import Step from '$lib/components/Step/Step.svelte';
	import DownloadIcon from 'virtual:icons/mdi/download';
	import RefreshIcon from 'virtual:icons/mdi/refresh';
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();

	const api = getApi();

	let folderPath = $state<string | undefined>(data.folderPath);
	// Initialize status based on existing script action ID
	let scriptInstallationStatus = $state<StepStatus>(data.scriptActionId && data.scriptActionId.trim() !== '' ? 'completed' : 'pending');
	let isRefreshing = $state<boolean>(false);
	let hasCheckedInitially = $state<boolean>(false);

	const nextSteps = [
		{ label: 'Add your songs', href: '/song' },
		{ label: 'Create setlists', href: '/' }
	];

	const setupSteps = [
		{ label: 'Download the Reaper Setlist script from the link below.' },
		{ label: 'Open Reaper and go to "Actions" > "Show Action List".' },
		{ label: 'Search for "ReaScript: Run Script" (the one with command ID 41060) ' },
		{ label: 'Locate the script you downloaded and click "Load" to install it into Reaper.' },
		{ label: 'The script will automatically register itself. Use the refresh button below to check installation status.' },
		{ label: 'Enter the root folder path where your backing tracks are stored in the form below.' },
		{ label: 'Click "Save" to store these settings.' }
	];

	// Only check script installation status once on initial load if not already completed
	$effect(() => {
		if (!hasCheckedInitially && scriptInstallationStatus !== 'completed') {
			hasCheckedInitially = true;
			checkScriptInstallation();
		}
	});

	async function handleSubmit(event: Event) {
		event.preventDefault();
		const formData = new FormData(event.target as HTMLFormElement);
		const folderPathValue = formData.get('backing-tracks-folder') || '';

		try {
			// Update folder path in the store
			await configuration.updateFolderPath(folderPathValue as string);

			notifications.success('Settings saved successfully!');

			// Update local state to reflect the saved values
			folderPath = folderPathValue as string;
		} catch (error) {
			notifications.error(`Failed to save settings: ${(error as Error).message}`);
			return;
		}
	}

	async function checkScriptInstallation() {
		if (isRefreshing) return;

		isRefreshing = true;
		scriptInstallationStatus = 'running';

		try {
			// Try to get the script action ID from the backend
			const actionId = await api.scriptSettings.getScriptActionId();

			if (actionId && actionId.trim() !== '') {
				scriptInstallationStatus = 'completed';
			} else {
				scriptInstallationStatus = 'error';
			}
		} catch (error) {
			scriptInstallationStatus = 'error';
		} finally {
			isRefreshing = false;
		}
	}
</script>

<div class="content">
	<h1>Setup</h1>

	{#if scriptInstallationStatus === 'error'}
		<InstructionBox title="Script Installation" steps={setupSteps} variant="help" listType="ordered" />

		<a class="download-link" href={`${base}/lua/reaper-setlist.lua`} download="reaper-setlist.lua">
			<DownloadIcon />
			Download reaper-setlist.lua
		</a>
	{:else}
		<InstructionBox title="Next steps:" steps={nextSteps} variant="success" listType="unordered" />
	{/if}

	<div class="script-status">
		<Step
			title="Script Installation Status"
			description={scriptInstallationStatus === 'completed'
				? 'Script is installed and ready to use'
				: scriptInstallationStatus === 'running'
					? 'Checking installation status...'
					: 'Script not detected. Please install the script in Reaper and refresh.'}
			status={scriptInstallationStatus}
		/>
		<Button elementType="button" onclick={checkScriptInstallation} disabled={isRefreshing} variant="text">
			<RefreshIcon />
			Refresh Status
		</Button>
	</div>

	<Form onsubmit={handleSubmit}>
		<div class="form-group">
			<label for="backing-tracks-folder">Backing Tracks Root Folder:</label>
			<input bind:value={folderPath} type="text" id="backing-tracks-folder" name="backing-tracks-folder" placeholder="e.g., /path/to/your/backing/tracks" />
		</div>

		<div class="submit-section">
			<Button elementType="submit" color="success">Save</Button>
		</div>
	</Form>
</div>

<style>
	.content {
		margin: 0 auto;
		padding: 2rem;
		width: 100%;
		box-sizing: border-box;
	}

	@media (max-width: 768px) {
		.content {
			padding: 1rem;
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

	.script-status {
		display: flex;
		flex-direction: column;
		gap: 1rem;
		margin: 1rem 0;
	}

	.script-status :global(.step) {
		margin: 0;
	}
</style>
