<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import Form from '$lib/components/Form/Form.svelte';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';
	import type { ReaperSettings, TestConnectionRequest } from '$lib/models/reaper-settings';
	import { notifications } from '$lib';
	import type { PageData } from './$types';
	import { goto } from '$app/navigation';

	let { data }: { data: PageData } = $props();

	let folderPath = $state<string>(data.settings.folderPath);
	let reaperUrl = $state<string>(data.settings.reaperUrl);
	let username = $state<string>(data.settings.reaperUsername ?? '');
	let password = $state<string>(data.settings.reaperPassword ?? '');
	let useAuthentication = $state<boolean>(!!(data.settings.reaperUsername || data.settings.reaperPassword));

	// Visual feedback states
	let urlTestState = $state<'success' | 'error' | null>(null);
	let authFieldsState = $state<'success' | 'error' | null>(null);

	// Clear visual feedback when user types
	function clearUrlTestState() {
		urlTestState = null;
	}

	function clearAuthFieldsError() {
		authFieldsState = null;
	}

	const setupSteps = [
		{ label: 'Enter the root folder path where your backing tracks are stored in the form below.' },
		{ label: "In Reaper, under preferences > Control/OSC/Web, add a web browser interface if you haven't already." },
		{ label: 'Enter the URL of your Reaper web interface (e.g., http://localhost:8080) in the form below.' },
		{ label: 'If your Reaper web interface has authentication enabled, check the authentication box and enter your username and password.' },
		{ label: 'Click Test to make sure the connection to Reaper is working.' },
		{ label: 'Click "Save" to store these settings.' },
		{ label: 'After saving, you will be redirected to the script installation page.' }
	];

	async function testConnection() {
		if (!reaperUrl.trim()) {
			notifications.error('Please enter a Reaper URL first');
			return;
		}

		// Reset visual states
		urlTestState = null;
		authFieldsState = null;

		const testRequest: TestConnectionRequest = {
			reaper_url: reaperUrl,
			reaper_username: useAuthentication && username.trim() ? username.trim() : undefined,
			reaper_password: useAuthentication && password.trim() ? password.trim() : undefined
		};

		try {
			const response = await fetch('/api/settings/test-connection', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify(testRequest)
			});

			if (response.status === 401) {
				// 401 Unauthorized - URL is correct, but authentication required
				urlTestState = 'success'; // URL is working
				useAuthentication = true;
				authFieldsState = 'error';
				return;
			}

			if (response.status === 403) {
				// 403 Forbidden - URL is correct, but wrong credentials
				urlTestState = 'success'; // URL is working
				authFieldsState = 'error';
				return;
			}

			if (response.status === 204) {
				// Success - 204 No Content
				urlTestState = 'success';
				// If authentication was used and test succeeded, mark auth fields as success too
				if (useAuthentication && username.trim() && password.trim()) {
					authFieldsState = 'success';
				}
			} else {
				// Any other status is an error (network, 404, 500, etc.)
				urlTestState = 'error';
			}
		} catch (error) {
			urlTestState = 'error';
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

		if (useAuthentication && usernameValue && typeof usernameValue === 'string' && usernameValue.trim() !== '') {
			body.reaperUsername = usernameValue;
		}
		if (useAuthentication && passwordValue && typeof passwordValue === 'string' && passwordValue.trim() !== '') {
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
			if (!data.settings.listProjectsScriptActionId || !data.settings.loadProjectScriptActionId) {
				await goto('/setup/installation');
			}
		}
	}
</script>

<div class="content">
	<h1>Setup</h1>

	<InstructionBox title="Setup Steps" steps={setupSteps} variant="help" listType="ordered" />

	<Form onsubmit={handleSubmit}>
		<div class="form-group">
			<label for="backing-tracks-folder">Backing Tracks Root Folder:</label>
			<input bind:value={folderPath} type="text" id="backing-tracks-folder" name="backing-tracks-folder" placeholder="e.g., /path/to/your/backing/tracks" />
		</div>

		<div class="checkbox-group">
			<label class="checkbox-label">
				<input type="checkbox" bind:checked={useAuthentication} />
				Enable Reaper Authentication
			</label>
		</div>

		{#if useAuthentication}
			<div class="form-group">
				<label for="reaper-username">Reaper Username:</label>
				<input
					bind:value={username}
					type="text"
					id="reaper-username"
					name="reaper-username"
					placeholder="Username"
					class:success={authFieldsState === 'success'}
					class:error={authFieldsState === 'error'}
					oninput={clearAuthFieldsError}
				/>
			</div>

			<div class="form-group">
				<label for="reaper-password">Reaper Password:</label>
				<input
					bind:value={password}
					type="password"
					id="reaper-password"
					name="reaper-password"
					placeholder="Password"
					class:success={authFieldsState === 'success'}
					class:error={authFieldsState === 'error'}
					oninput={clearAuthFieldsError}
				/>
			</div>
		{/if}

		<div class="form-group">
			<label for="reaper-url">Reaper URL:</label>
			<div class="url-input-container input-with-button">
				<input
					bind:value={reaperUrl}
					type="text"
					id="reaper-url"
					name="reaper-url"
					placeholder="e.g., http://localhost:8080"
					class:success={urlTestState === 'success'}
					class:error={urlTestState === 'error'}
					oninput={clearUrlTestState}
				/>
				<Button variant="text" onclick={testConnection}>Test</Button>
			</div>
		</div>

		<div class="submit-section">
			<Button elementType="submit" color="primary">Save</Button>
		</div>
	</Form>
</div>

<style>
	.content {
		max-width: 800px;
		margin: 0 auto;
		padding: 2rem;
	}

	.checkbox-label {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		cursor: pointer;
		font-weight: 500;
		width: fit-content;
		white-space: nowrap;
		margin: 0;
	}

	.checkbox-label input[type='checkbox'] {
		margin: 0;
		flex-shrink: 0;
		width: auto;
	}

	@media (max-width: 768px) {
		.content {
			padding: 1rem;
		}
	}
</style>
