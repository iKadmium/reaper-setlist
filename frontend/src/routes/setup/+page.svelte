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
	import ExportIcon from 'virtual:icons/mdi/export';
	import ImportIcon from 'virtual:icons/mdi/import';
	import type { PageProps } from './$types';
	import type { Backup } from '$lib/models/backup';

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

	async function exportData() {
		const allSongs = await api.songs.list();
		const allSetlists = await api.sets.list();
		const dataToExport: Backup = {
			songs: allSongs,
			sets: allSetlists
		};
		const jsonData = JSON.stringify(dataToExport, null, 2);
		const blob = new Blob([jsonData], { type: 'application/json' });
		const url = URL.createObjectURL(blob);
		const link = document.createElement('a');
		link.href = url;
		link.download = 'reaper-setlist-data.json';
		document.body.appendChild(link);
		link.click();
		document.body.removeChild(link);
		URL.revokeObjectURL(url);
		notifications.success('Data exported successfully!');
	}

	async function importData() {
		const fileInput = document.createElement('input');
		fileInput.type = 'file';
		fileInput.accept = '.json';
		fileInput.onchange = async (event: Event) => {
			const target = event.target as HTMLInputElement;
			if (target.files && target.files.length > 0) {
				const file = target.files[0];
				try {
					const text = await file.text();
					const importedData = JSON.parse(text) as Backup;

					// Step 1: Import songs and create ID mapping
					const oldToNewSongIdMap = new Map<string, string>();

					for (const song of Object.values(importedData.songs)) {
						const { id, ...songWithoutId } = song;
						const newSong = await api.songs.add(songWithoutId);
						oldToNewSongIdMap.set(id, newSong.id);
					}

					// Step 2: Import setlists with updated song IDs
					for (const setlist of Object.values(importedData.sets)) {
						const { id, ...setlistWithoutId } = setlist;
						const updatedSetlist = {
							...setlistWithoutId,
							songs: setlist.songs.map((oldSongId) => oldToNewSongIdMap.get(oldSongId) || oldSongId)
						};
						await api.sets.add(updatedSetlist);
					}

					notifications.success('Data imported successfully!');
				} catch (error) {
					notifications.error(`Failed to import data: ${(error as Error).message}`);
				}
			}
		};
		fileInput.click();
	}
</script>

<div class="content">
	<h1>Setup</h1>

	{#if scriptInstallationStatus === 'error'}
		<InstructionBox title="Script Installation" steps={setupSteps} variant="help" listType="ordered" />
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

	<div class="import-export">
		<h3>Data Management</h3>
		<div class="import-export-buttons">
			<Button elementType="button" onclick={exportData} variant="text">
				<ExportIcon />
				Export Data
			</Button>
			<Button elementType="button" onclick={importData} variant="text">
				<ImportIcon />
				Import Data
			</Button>
		</div>
	</div>
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

	.script-status {
		display: flex;
		flex-direction: column;
		gap: 1rem;
		margin: 1rem 0;
	}

	.script-status :global(.step) {
		margin: 0;
	}

	.import-export {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		margin-top: 2rem;
	}

	.import-export-buttons {
		display: flex;
		gap: 1rem;
	}
</style>
