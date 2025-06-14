<script lang="ts">
	import { configuration, notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import Button from '$lib/components/Button/Button.svelte';
	import Form from '$lib/components/Form/Form.svelte';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';
	import type { StepStatus } from '$lib/components/Step/Step.svelte';
	import Step from '$lib/components/Step/Step.svelte';
	import type { Backup } from '$lib/models/backup';
	import { generateUUID } from '$lib/util';
	import ExportIcon from 'virtual:icons/mdi/export';
	import ImportIcon from 'virtual:icons/mdi/import';
	import RefreshIcon from 'virtual:icons/mdi/refresh';
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();

	const api = getApi();

	let folderPath = $state<string | undefined>(data.folderPath);
	// Initialize status based on existing script action ID
	let scriptInstallationStatus = $state<StepStatus>(data.scriptActionId && data.scriptActionId.trim() !== '' ? 'completed' : 'pending');
	let isRefreshing = $state<boolean>(false);
	let hasCheckedInitially = $state<boolean>(false);

	// Folder validation state
	let folderValidationStatus = $state<'pending' | 'checking' | 'success' | 'warning' | 'error'>('pending');
	let folderValidationMessage = $state<string>('');
	let lastValidatedPath = $state<string | undefined>(data.folderPath);

	const nextSteps = [
		{ label: 'Add your songs', href: '/song' },
		{ label: 'Create setlists', href: '/' }
	];

	const setupSteps = [
		{ label: 'Open Reaper and go to "Actions" > "Show Action List".' },
		{ label: 'If you installed this via ReaPack, the reaper-setlist.lua script should already be listed here.' },
		{ label: 'If not, click "New Action" > "Load ReaScript..." and open the reaper-setlist.lua script.' },
		{ label: 'Simply run the script to register it.' },
		{ label: 'Use the refresh button below to check installation status.' },
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

	// Reset validation status when folder path changes (user is typing)
	$effect(() => {
		if (folderPath !== lastValidatedPath && folderValidationStatus !== 'pending') {
			folderValidationStatus = 'pending';
			folderValidationMessage = '';
		}
	});

	async function handleSubmit(event: Event) {
		event.preventDefault();
		const formData = new FormData(event.target as HTMLFormElement);
		const folderPathValue: string = formData.get('backing-tracks-folder')?.toString() || '';
		let escapedFolderPath = folderPathValue.replaceAll('\\', '/'); // Normalize path for consistency
		while (escapedFolderPath.includes('//')) {
			escapedFolderPath = escapedFolderPath.replace('//', '/'); // Remove any double slashes
		}

		// Start validation
		folderValidationStatus = 'checking';
		folderValidationMessage = 'Validating folder...';

		try {
			// Update folder path in the store
			await configuration.updateFolderPath(escapedFolderPath);
			const projects = await api.script.listProjects();

			if (projects.length > 0) {
				folderValidationStatus = 'success';
				folderValidationMessage = `Found ${projects.length} project${projects.length === 1 ? '' : 's'}`;
				notifications.success('Settings saved successfully!');
			} else {
				folderValidationStatus = 'warning';
				folderValidationMessage = 'No .rpp files found in this folder';
				notifications.warning('Settings saved but no projects were found. Please double-check the folder path.');
			}

			// Update local state to reflect the saved values
			folderPath = escapedFolderPath;
			lastValidatedPath = escapedFolderPath;
		} catch (error) {
			folderValidationStatus = 'error';
			folderValidationMessage = `Error: ${(error as Error).message}`;
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
				const nonce = generateUUID();
				const result = await api.script.testActionId(nonce);
				if (result === `Test action ID received: ${actionId}`) {
					// If the action ID is valid, update the status to completed
					scriptInstallationStatus = 'completed';
				} else {
					// If the action ID is not valid, set status to error
					scriptInstallationStatus = 'error';
				}
				scriptInstallationStatus = 'completed';
			} else {
				scriptInstallationStatus = 'error';
			}
		} catch (error) {
			console.error('Error checking script installation:', error);
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
						const { ...setlistWithoutId } = setlist;
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
			<input
				bind:value={folderPath}
				type="text"
				id="backing-tracks-folder"
				name="backing-tracks-folder"
				placeholder="e.g., /path/to/your/backing/tracks"
				class={folderValidationStatus === 'success'
					? 'success'
					: folderValidationStatus === 'warning'
						? 'warning'
						: folderValidationStatus === 'error'
							? 'error'
							: ''}
			/>
			{#if folderValidationMessage}
				<div class="validation-message validation-message--{folderValidationStatus}">
					{folderValidationMessage}
				</div>
			{:else if folderPath && folderPath.trim() !== '' && folderPath !== lastValidatedPath}
				<div class="validation-message validation-message--pending">Click "Save" to validate this folder path</div>
			{/if}
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

	.validation-message {
		font-size: 0.875rem;
		margin-top: 0.5rem;
		padding: 0.25rem 0;
	}

	.validation-message--success {
		color: var(--green);
	}

	.validation-message--warning {
		color: var(--yellow);
	}

	.validation-message--error {
		color: var(--red);
	}

	.validation-message--checking {
		color: var(--comment);
	}

	.validation-message--pending {
		color: var(--comment);
		font-style: italic;
	}
</style>
