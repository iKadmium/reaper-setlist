<script lang="ts">
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import Button from '$lib/components/Button/Button.svelte';
	import type { StepStatus } from '$lib/components/Step/Step.svelte';
	import Step from '$lib/components/Step/Step.svelte';
	import type { Database } from '$lib/models/database';
	import type { Setlist } from '$lib/models/setlist';
	import type { Song } from '$lib/models/song';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	let working = $state<boolean>(false);
	let hasExecuted = $state<boolean>(false);
	let replaceExistingTabs = $state<boolean>(true);
	let movePlayheadToStart = $state<boolean>(true);
	let set = $state<Setlist | undefined>(data.set);
	let songs = $state<Database<Song>>(data.songs);
	const errorMessage = data.error;

	const api = getApi();

	interface LoadStep {
		id: string;
		title: string;
		description?: string;
		status: StepStatus;
		action: () => Promise<boolean>;
	}

	let steps = $state<LoadStep[]>([]);

	// Generate steps when set or replace option changes, but only if we haven't executed yet
	$effect(() => {
		if (set && !working && !hasExecuted) {
			generateSteps();
		}
		// This effect will re-run when replaceExistingTabs or movePlayheadToStart changes
		void replaceExistingTabs;
		void movePlayheadToStart;
	});

	function generateSteps() {
		if (!set) return;

		const newSteps: LoadStep[] = [];

		// Add initial step based on the replace existing tabs option
		if (replaceExistingTabs) {
			newSteps.push({
				id: 'close-all-tabs',
				title: 'Close All Tabs',
				description: 'Close all existing tabs in Reaper before loading the setlist',
				status: 'pending',
				action: () => closeAllTabs()
			});
		}

		set.songs.forEach((songId, index) => {
			const song = songs[songId];

			// Add new tab step for all songs except the first, or for first song if not replacing tabs
			if (index > 0 || !replaceExistingTabs) {
				newSteps.push({
					id: index === 0 ? 'open-new-tab-initial' : `new-tab-${index}`,
					title: 'Open New Tab',
					description: index === 0 ? `Create a new tab in Reaper for the setlist` : `Create a new tab in Reaper for ${song.name}`,
					status: 'pending',
					action: () => newTab()
				});
			}

			// Add load song step
			newSteps.push({
				id: `load-song-${songId}`,
				title: `Load ${song.name}`,
				description: `Load the project file for ${song.name}`,
				status: 'pending',
				action: () => loadSong(song)
			});

			// Add go to start step only if movePlayheadToStart is enabled
			if (movePlayheadToStart) {
				newSteps.push({
					id: `go-to-start-${index}`,
					title: 'Move Playhead to Start',
					description: `Position the playhead at the beginning of ${song.name}`,
					status: 'pending',
					action: () => goToStart()
				});
			}
		});

		steps = newSteps;
	}

	async function loadSong(song: Song): Promise<boolean> {
		try {
			await api.script.openProject(song.path);
			return true;
		} catch (error) {
			notifications.error(`Failed to load song "${song.name}": ${(error as Error).message}`);
			return false;
		}
	}

	async function newTab(): Promise<boolean> {
		try {
			await api.reaper.newTab();
			return true;
		} catch (error) {
			notifications.error(`Failed to open new tab: ${(error as Error).message}`);
			return false;
		}
	}

	async function closeAllTabs(): Promise<boolean> {
		try {
			await api.reaper.closeAllTabs();
			return true;
		} catch (error) {
			notifications.error(`Failed to close all tabs: ${(error as Error).message}`);
			return false;
		}
	}

	async function goToStart(): Promise<boolean> {
		try {
			await api.reaper.goToStart();
			return true;
		} catch (error) {
			notifications.error(`Failed to move playhead to start: ${(error as Error).message}`);
			return false;
		}
	}

	function updateStepStatus(stepId: string, status: StepStatus) {
		const stepIndex = steps.findIndex((s) => s.id === stepId);
		if (stepIndex !== -1) {
			steps[stepIndex].status = status;
		}
	}

	async function executeStep(step: LoadStep): Promise<boolean> {
		updateStepStatus(step.id, 'running');

		try {
			let success = false;
			success = await step.action();

			updateStepStatus(step.id, success ? 'completed' : 'error');
			return success;
		} catch (error) {
			console.error(`Error executing step ${step.id}:`, error);
			updateStepStatus(step.id, 'error');
			return false;
		}
	}

	async function loadSet() {
		if (!set || working) return;

		// Reset steps if they have been executed before
		if (hasExecuted) {
			hasExecuted = false;
			generateSteps();
		}

		if (steps.length === 0) return;

		working = true;
		hasExecuted = true;

		try {
			for (const step of steps) {
				const success = await executeStep(step);

				// If a step fails, we could either continue or stop
				// For now, let's continue even if a step fails
				if (!success) {
					console.warn(`Step ${step.id} failed, but continuing...`);
				}

				// Small delay between steps for better UX
				await new Promise((resolve) => setTimeout(resolve, 200));
			}
		} catch (error) {
			console.error('Error during setlist loading:', error);
		} finally {
			working = false;
		}
	}
</script>

<meta:head>
	<title>Load Set - Reaper Setlist</title>
</meta:head>

<h1>Load Set</h1>

{#if errorMessage}
	<p style="color: red;">{errorMessage}</p>
{:else if set}
	<div class="options-container">
		<label class="checkbox-label">
			<input type="checkbox" bind:checked={replaceExistingTabs} disabled={working} />
			Replace existing tabs (close all tabs before loading)
		</label>

		<label class="checkbox-label">
			<input type="checkbox" bind:checked={movePlayheadToStart} disabled={working} />
			Move playhead to start for each song
		</label>
	</div>

	<div class="load-button-container">
		<Button onclick={loadSet} disabled={working}>
			{working ? 'Loading...' : hasExecuted ? 'Load Again' : 'Load Set'}
		</Button>
	</div>

	{#if steps.length > 0}
		<div class="steps-container">
			{#each steps as step (step.id)}
				<Step title={step.title} description={step.description} status={step.status} />
			{/each}
		</div>
	{/if}
{:else}
	<p>Set not found.</p>
{/if}

<style>
	.options-container {
		margin-bottom: 1.5rem;
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
	}

	.checkbox-label {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		font-size: 1rem;
		cursor: pointer;
		user-select: none;
	}

	.checkbox-label input[type='checkbox'] {
		width: auto;
		margin: 0;
		cursor: pointer;
	}

	.checkbox-label:has(input:disabled) {
		opacity: 0.6;
		cursor: not-allowed;
	}

	.steps-container {
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
		width: 100%;
		margin: 1rem 0;
	}

	.load-button-container {
		display: flex;
		justify-content: center;
	}
</style>
