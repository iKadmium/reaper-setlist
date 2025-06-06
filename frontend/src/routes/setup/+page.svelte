<script lang="ts">
	import { goto } from '$app/navigation';
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import Button from '$lib/components/Button/Button.svelte';
	import Form from '$lib/components/Form/Form.svelte';
	import InstructionBox from '$lib/components/InstructionBox/InstructionBox.svelte';
	import type { PageProps } from './$types';

	let { data }: PageProps = $props();

	const api = getApi();

	let folderPath = $state<string | undefined>(data.folderPath);

	const setupSteps = [
		{ label: 'Enter the root folder path where your backing tracks are stored in the form below.' },
		{ label: "In Reaper, under preferences > Control/OSC/Web, add a web browser interface if you haven't already." },
		{ label: 'Enter the URL of your Reaper web interface (e.g., http://localhost:8080) in the form below.' },
		{ label: 'If your Reaper web interface has authentication enabled, check the authentication box and enter your username and password.' },
		{ label: 'Click Test to make sure the connection to Reaper is working.' },
		{ label: 'Click "Save" to store these settings.' },
		{ label: 'After saving, you will be redirected to the script installation page.' }
	];

	async function handleSubmit(event: Event) {
		event.preventDefault();
		const formData = new FormData(event.target as HTMLFormElement);
		const folderPathValue = formData.get('backing-tracks-folder') || '';

		try {
			await api.settings.setFolderPath(folderPathValue as string);
			notifications.success('Settings saved successfully!');
			if (!data.scriptActionId) {
				await goto('/setup/installation');
			}
		} catch (error) {
			notifications.error(`Failed to set folder path: ${(error as Error).message}`);
			return;
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

	@media (max-width: 768px) {
		.content {
			padding: 1rem;
		}
	}
</style>
