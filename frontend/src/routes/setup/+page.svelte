<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import Form from '$lib/components/Form/Form.svelte';
	import UrlInput from '$lib/components/UrlInput/UrlInput.svelte';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';
	import SaveIcon from 'virtual:icons/mdi/content-save';
	import type { ReaperSettings, TestConnectionRequest, TestConnectionResponse } from '$lib/models/reaper-settings';
	import { notifications } from '$lib';
	import type { PageData } from './$types';
	import { goto } from '$app/navigation';

	let { data }: { data: PageData } = $props();

	let folderPath = $state<string>(data.settings.folderPath);
	let reaperUrl = $state<string>(data.settings.reaperUrl);
	let username = $state<string>(data.settings.reaperUsername ?? '');
	let password = $state<string>(data.settings.reaperPassword ?? '');
	// Store the original folder path to detect changes
	const originalFolderPath = data.settings.folderPath;

	const setupSteps = [
		{ label: "In Reaper, under preferences > Control/OSC/Web, add a web browser interface if you haven't already." },
		{ label: 'Enter the root folder path where your backing tracks are stored and the Access URL from the web browser interface in the form above.' },
		{ label: 'Click "Save" and then proceed to the installation page to download and configure the required scripts.' }
	];

	async function testConnection() {
		if (!reaperUrl.trim()) {
			notifications.error('Please enter a Reaper URL first');
			return;
		}

		const testRequest: TestConnectionRequest = {
			reaper_url: reaperUrl,
			reaper_username: username.trim() || undefined,
			reaper_password: password.trim() || undefined
		};

		try {
			const response = await fetch('/api/settings/test-connection', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify(testRequest)
			});

			if (!response.ok) {
				notifications.error('Failed to test connection');
				return;
			}

			const result: TestConnectionResponse = await response.json();
			if (result.success) {
				notifications.success(result.message);
			} else {
				notifications.error(result.message);
			}
		} catch (error) {
			notifications.error('Failed to test connection: Network error');
		}
	}

	async function handleSubmit(event: Event) {
		event.preventDefault();
		const formData = new FormData(event.target as HTMLFormElement);
		const reaperUrlValue = formData.get('reaper-url') || '';
		const folderPathValue = formData.get('backing-tracks-folder') || '';
		const usernameValue = formData.get('reaper-username');
		const passwordValue = formData.get('reaper-password');

		const body: ReaperSettings = {
			reaperUrl: reaperUrlValue ? (reaperUrlValue as string) : '',
			folderPath: folderPathValue ? (folderPathValue as string) : ''
		};

		if (usernameValue && typeof usernameValue === 'string' && usernameValue.trim() !== '') {
			body.reaperUsername = usernameValue;
		}
		if (passwordValue && typeof passwordValue === 'string' && passwordValue.trim() !== '') {
			body.reaperPassword = passwordValue;
		}

		const res = await fetch('/api/settings', {
			method: 'PUT',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify(body)
		});
		if (!res.ok) {
			notifications.error('Failed to save settings');
			return;
		} else {
			notifications.success('Settings saved successfully!');

			// Always redirect to installation after saving basic settings
			if (data.settings.listProjectsScriptActionId && data.settings.loadProjectScriptActionId) {
				await goto('/song');
			} else {
				await goto('/setup/installation');
			}
		}
	}
</script>

<meta:head>
	<title>Setup - Reaper Setlist</title>
</meta:head>

<h1>Setup</h1>

<InstructionBox title="Setup Help" steps={setupSteps} variant="help" listType="ordered" />

<Form onsubmit={handleSubmit}>
	<div class="form-group">
		<label for="backing-tracks-folder">Backing Tracks Root Folder:</label>
		<input bind:value={folderPath} type="text" id="backing-tracks-folder" name="backing-tracks-folder" placeholder="e.g., /path/to/your/backing/tracks" />
	</div>

	<div class="form-group">
		<label for="reaper-url">Reaper URL:</label>
		<UrlInput bind:value={reaperUrl} id="reaper-url" name="reaper-url" placeholder="e.g., http://localhost:8080" onTest={testConnection} />
	</div>

	<div class="form-group">
		<label for="reaper-username">Reaper Username (optional):</label>
		<input bind:value={username} type="text" id="reaper-username" name="reaper-username" placeholder="Username (if authentication is enabled)" />
	</div>

	<div class="form-group">
		<label for="reaper-password">Reaper Password (optional):</label>
		<input bind:value={password} type="password" id="reaper-password" name="reaper-password" placeholder="Password (if authentication is enabled)" />
	</div>

	<div class="submit-section">
		<Button elementType="submit" color="primary">
			<SaveIcon />
			Save Settings
		</Button>
	</div>
</Form>
