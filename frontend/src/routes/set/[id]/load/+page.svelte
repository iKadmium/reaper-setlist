<script lang="ts">
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import { Commands } from '$lib/api/reaper-backend/commands';
	import Button from '$lib/components/Button/Button.svelte';
	import type { StepStatus } from '$lib/components/Step/Step.svelte';
	import Step from '$lib/components/Step/Step.svelte';
	import type { Database } from '$lib/models/database';
	import type { ReaperTab } from '$lib/models/reaper-tab';
	import type { Setlist } from '$lib/models/setlist';
	import type { Song } from '$lib/models/song';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	let working = $state<boolean>(false);
	let hasExecuted = $state<boolean>(false);
	let replaceExistingTabs = $state<boolean>(true);
	let movePlayheadToStart = $state<boolean>(true);
	let tabsBeforeLoad = $state<ReaperTab[]>(data.tabs.tabs);
	let set = $state<Setlist | undefined>(data.set);
	let songs = $state<Database<Song>>(data.songs);
	let anyDirty = $derived(tabsBeforeLoad.some((tab) => tab.dirty));
	let checkingTabs = $state<boolean>(false);
	let shouldDisableLoad = $derived(replaceExistingTabs && anyDirty);
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

		// Add step to switch to the first song tab after all songs are loaded
		if (set.songs.length > 0) {
			newSteps.push({
				id: 'switch-to-first-song',
				title: 'Switch to First Song',
				description: 'Navigate to the first song tab in the setlist',
				status: 'pending',
				action: () => switchToFirstSong()
			});
		}

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

	async function switchToFirstSong(): Promise<boolean> {
		try {
			// Calculate how many tabs to skip to get to the first song
			let targetTabIndex: number;
			const tabs = await api.script.getOpenTabs();
			const currentTabIndex = tabs.activeIndex;

			if (replaceExistingTabs) {
				// If we closed all tabs, the first song is at tab 0, so no skipping needed
				targetTabIndex = 0;
			} else {
				// If we didn't close tabs, we need to skip the original tabs to get to the first new tab
				targetTabIndex = data.tabs.tabs.length;
			}

			const tabsToSkip = targetTabIndex - currentTabIndex;

			// If we need to skip tabs, send multiple nextTab commands in a batch
			if (tabsToSkip > 0) {
				// Create an array of nextTab commands and execute them in a batch
				const commands = Array(tabsToSkip)
					.fill(0)
					.map(() => Commands.nextTab());
				await api.reaper.executeCommands(commands);
			} else if (tabsToSkip < 0) {
				// If we need to go back, we can use previousTab
				const commands = Array(-tabsToSkip)
					.fill(0)
					.map(() => Commands.previousTab());
				await api.reaper.executeCommands(commands);
			}

			return true;
		} catch (error) {
			notifications.error(`Failed to switch to first song: ${(error as Error).message}`);
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

	async function refreshTabs() {
		if (checkingTabs) return;

		checkingTabs = true;
		try {
			const response = await api.script.getOpenTabs();
			tabsBeforeLoad = response.tabs;
		} catch (error) {
			notifications.error(`Failed to refresh tabs: ${(error as Error).message}`);
		} finally {
			checkingTabs = false;
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

		tabsBeforeLoad = (await api.script.getOpenTabs()).tabs;

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
		<Button onclick={loadSet} disabled={working || shouldDisableLoad}>
			{working ? 'Loading...' : hasExecuted ? 'Load Again' : 'Load Set'}
		</Button>
	</div>

	{#if shouldDisableLoad}
		<div class="warning-container">
			<div class="warning-message">
				<h3>⚠️ Unsaved Changes Detected</h3>
				<p>
					You have unsaved changes in {tabsBeforeLoad.filter((tab) => tab.dirty).length} tab{tabsBeforeLoad.filter((tab) => tab.dirty).length === 1 ? '' : 's'}.
					Since "Replace existing tabs" is enabled, these changes will be lost when loading the set.
				</p>
				<div class="dirty-tabs-list">
					<p><strong>Tabs with unsaved changes:</strong></p>
					<ul class="dirty-tabs">
						{#each tabsBeforeLoad.filter((tab) => tab.dirty) as dirtyTab (dirtyTab.index)}
							<li class="dirty-tab">
								<span class="tab-name">{dirtyTab.name || 'Untitled'}</span>
								<span class="tab-index">(Tab {dirtyTab.index + 1})</span>
							</li>
						{/each}
					</ul>
				</div>
				<p><strong>What to do:</strong></p>
				<ul>
					<li>Save your changes in Reaper, then click "Check Again" below</li>
					<li>Or disable "Replace existing tabs" to keep your current tabs</li>
				</ul>
				<Button onclick={refreshTabs} disabled={checkingTabs} variant="text">
					{checkingTabs ? 'Checking...' : 'Check Again'}
				</Button>
			</div>
		</div>
	{/if}

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

	.warning-container {
		margin: 1rem 0;
		display: flex;
		justify-content: center;
	}

	.warning-message {
		background-color: hsl(from var(--yellow) h s l / 0.1);
		border: 1px solid var(--yellow);
		border-radius: 0.5rem;
		padding: 1rem;
		max-width: 600px;
		width: 100%;
	}

	.warning-message h3 {
		margin: 0 0 0.5rem 0;
		color: var(--yellow);
		font-size: 1.1rem;
	}

	.warning-message p {
		margin: 0.5rem 0;
		line-height: 1.4;
	}

	.warning-message ul {
		margin: 0.5rem 0;
		padding-left: 1.5rem;
	}

	.warning-message li {
		margin: 0.25rem 0;
		line-height: 1.4;
	}

	.dirty-tabs-list {
		margin: 1rem 0;
		padding: 0.75rem;
		background-color: hsl(from var(--background) h s calc(l * 0.8));
		border-radius: 0.25rem;
		border-left: 3px solid var(--yellow);
	}

	.dirty-tabs-list p {
		margin: 0 0 0.5rem 0;
		font-weight: 500;
	}

	.dirty-tabs {
		margin: 0;
		padding-left: 1rem;
		list-style: none;
	}

	.dirty-tab {
		margin: 0.25rem 0;
		padding: 0.25rem 0;
		display: flex;
		align-items: center;
		gap: 0.5rem;
	}

	.dirty-tab::before {
		content: '•';
		color: var(--yellow);
		font-weight: bold;
		margin-right: 0.25rem;
	}

	.tab-name {
		font-weight: 500;
		color: var(--foreground);
	}

	.tab-index {
		color: var(--comment);
		font-size: 0.9rem;
	}
</style>
