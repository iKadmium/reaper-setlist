<script lang="ts">
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';

	import Button from '$lib/components/Button/Button.svelte';
	import type { ReaperMarker } from '$lib/models/reaper-marker';
	import type { ReaperTab } from '$lib/models/reaper-tab';
	import {
		PLAYSTATE_PAUSED,
		PLAYSTATE_PLAYING,
		PLAYSTATE_RECORDING,
		PLAYSTATE_STOPPED,
		type PlayState,
		type ReaperTransport
	} from '$lib/models/reaper-transport';
	import { formatDuration } from '$lib/util';
	import { onDestroy, onMount } from 'svelte';
	// Icons
	import PauseIcon from 'virtual:icons/mdi/pause';
	import PlayIcon from 'virtual:icons/mdi/play';
	import RecordIcon from 'virtual:icons/mdi/record';
	import SkipNextIcon from 'virtual:icons/mdi/skip-next';
	import SkipPreviousIcon from 'virtual:icons/mdi/skip-previous';
	import StopIcon from 'virtual:icons/mdi/stop';

	const api = getApi();

	// Player state
	let allTabs = $state<ReaperTab[] | null>(null);
	let currentSongIndex = $state<number>(0);
	let playState = $state<PlayState>(PLAYSTATE_STOPPED);
	let currentSongTime = $state<number>(0);
	let totalSetTime = $derived<number>(
		!allTabs
			? 0
			: allTabs.slice(0, currentSongIndex).reduce((total, tab) => {
					return total + (tab.length || 0);
				}, 0) + currentSongTime
	);
	let transportUpdateHandle = $state<number | null>(null);
	let tabsUpdateHandle = $state<number | null>(null);

	// Current song data
	const currentTab = $derived(!allTabs || currentSongIndex < 0 || currentSongIndex >= allTabs.length ? null : allTabs[currentSongIndex] || null);

	// Song markers (placeholder data - would come from Reaper)
	let songMarkers = $state<ReaperMarker[]>([]);

	// Time calculations
	const totalSongDuration = $derived(currentTab?.length || 0);
	const remainingSongTime = $derived(Math.max(0, totalSongDuration - currentSongTime));
	const totalSetDuration = $derived(
		!allTabs
			? 0
			: allTabs.reduce((total, tab) => {
					return total + (tab.length || 0);
				}, 0)
	);
	const remainingSetTime = $derived(
		!allTabs
			? 0
			: (() => {
					let remaining = 0;
					for (let i = currentSongIndex; i < allTabs.length; i++) {
						const tab = allTabs[i];
						const songDuration = tab.length || 0;
						if (i === currentSongIndex) {
							remaining += Math.max(0, songDuration - currentSongTime);
						} else {
							remaining += songDuration;
						}
					}
					return remaining;
				})()
	);

	// Progress percentages
	const songProgress = $derived(totalSongDuration === 0 ? 0 : Math.min(100, (currentSongTime / totalSongDuration) * 100));
	const setProgress = $derived(totalSetDuration === 0 ? 0 : Math.min(100, (totalSetTime / totalSetDuration) * 100));

	// Format time for display
	function formatTime(seconds: number): string {
		const mins = Math.floor(seconds / 60);
		const secs = Math.floor(seconds % 60);
		return `${mins}:${secs.toString().padStart(2, '0')}`;
	}

	function formatTitle(title: string): string {
		// strip file extension and trim whitespace
		return title.replace(/\.[^/.]+$/, ''); // Remove file extension
	}

	// Player controls
	async function togglePlayPause() {
		try {
			if (playState === PLAYSTATE_PLAYING) {
				const transport = await api.reaper.pause();
				updateTransport(transport);
			} else if (playState === PLAYSTATE_PAUSED || playState === PLAYSTATE_STOPPED) {
				const transport = await api.reaper.play();
				updateTransport(transport);
			}
		} catch (error) {
			notifications.error(`Failed to toggle playback: ${(error as Error).message}`);
		}
	}

	async function stop() {
		try {
			const transport = await api.reaper.stop();
			updateTransport(transport);
		} catch (error) {
			notifications.error(`Failed to stop playback: ${(error as Error).message}`);
		}
	}

	async function previousTrack() {
		if (currentSongIndex > 0) {
			currentSongIndex--;
			const result = await api.reaper.previousTab();
			updateMarkers(result.markers);
			updateTransport(result.transport);
		}
	}

	async function nextTrack() {
		if (allTabs && currentSongIndex < allTabs.length - 1) {
			currentSongIndex++;
			const result = await api.reaper.nextTab();
			updateMarkers(result.markers);
			updateTransport(result.transport);
		}
	}

	async function goToMarker(marker: ReaperMarker) {
		try {
			const transport = await api.reaper.goToMarker(marker.id);
			updateTransport(transport);
		} catch (error) {
			notifications.error(`Failed to jump to marker: ${(error as Error).message}`);
			console.error(`Failed to jump to marker:`, error);
		}
	}

	async function goToStart() {
		try {
			const transport = await api.reaper.goToStart();
			updateTransport(transport);
		} catch (error) {
			notifications.error(`Failed to jump to song start: ${(error as Error).message}`);
			console.error(`Failed to jump to song start:`, error);
		}
	}

	async function startRecording() {
		try {
			const transport = await api.reaper.record();
			updateTransport(transport);
		} catch (error) {
			notifications.error(`Failed to toggle recording: ${(error as Error).message}`);
			console.error(`Failed to toggle recording:`, error);
		}
	}

	function updateTransport(transport: ReaperTransport) {
		if (transport) {
			playState = transport.playState;
			currentSongTime = transport.positionSeconds;
		} else {
			playState = PLAYSTATE_STOPPED;
			currentSongTime = 0;
		}
	}

	function updateMarkers(markers: ReaperMarker[]) {
		songMarkers = markers;
	}

	async function refreshTransport() {
		try {
			const state = await api.reaper.getTransport();
			updateTransport(state);
		} catch (error) {
			console.error(`Failed to update transport:`, error);
		}
	}

	async function refreshMarkers() {
		try {
			const markers = await api.reaper.getMarkers();
			updateMarkers(markers);
		} catch (error) {
			console.error(`Failed to load markers:`, error);
		}
	}

	async function refreshTabs() {
		try {
			const response = await api.script.getOpenTabs();
			if (allTabs !== response.tabs || currentSongIndex !== response.activeIndex) {
				allTabs = response.tabs;
				currentSongIndex = response.activeIndex;
				await refreshMarkers(); // Refresh markers after tabs update
			}

			if (currentSongIndex < 0 || currentSongIndex >= allTabs.length) {
				currentSongIndex = 0; // Reset to first song if index is out of bounds
			}
		} catch (error) {
			console.error(`Failed to refresh tabs: ${(error as Error).message}`);
		}
	}

	// Load sample data (in real app, this would come from route params)
	onMount(async () => {
		try {
			tabsUpdateHandle = window.setInterval(refreshTabs, 5000); // Refresh tabs every 5 seconds
			transportUpdateHandle = window.setInterval(refreshTransport, 1000); // Update transport every second

			await refreshTabs(); // Load initial tabs
			await refreshMarkers(); // Load initial song markers
			await refreshTransport(); // Load initial transport state
		} catch (error) {
			notifications.error(`Failed to load initial data: ${(error as Error).message}`);
			console.error(`Failed to load data: ${(error as Error).message}`);
		}
	});

	// Cleanup
	onDestroy(() => {
		if (transportUpdateHandle) {
			window.clearInterval(transportUpdateHandle);
		}
		if (tabsUpdateHandle) {
			window.clearInterval(tabsUpdateHandle);
		}
	});
</script>

<meta:head>
	<title>Player - Reaper Setlist</title>
</meta:head>

<div class="player-container">
	<h1>Live Player</h1>

	{#if allTabs && currentTab}
		<!-- Current Song Display -->
		<div class="current-song-section">
			<div class="song-info">
				<div class="song-meta">
					<span class="song-number">Track {currentSongIndex + 1} of {allTabs.length}</span>
				</div>
				<h2 class="song-title">{formatTitle(currentTab.name)}</h2>
			</div>

			<div class="track-navigation">
				<Button variant="icon" onclick={previousTrack} disabled={currentSongIndex === 0}>
					<SkipPreviousIcon />
				</Button>

				<Button variant="icon" onclick={nextTrack} disabled={!allTabs || currentSongIndex >= allTabs.length - 1}>
					<SkipNextIcon />
				</Button>
			</div>

			<div class="next-up-info">
				<div class="next-up-header">
					<h4>Next Up</h4>
					{#if currentSongIndex < allTabs.length - 1}
						{@const nextTab = allTabs[currentSongIndex + 1]}
						{#if nextTab}
							<div class="next-song">
								<div class="next-song-name">{formatTitle(nextTab.name)}</div>
								<div class="next-song-duration">{formatDuration(nextTab.length)}</div>
							</div>
						{/if}
					{:else}
						<div class="set-complete">Set Complete!</div>
					{/if}
				</div>
			</div>
		</div>

		<!-- Transport Controls & Song Progress -->
		<div class="transport-section">
			<div class="transport-controls">
				<div class="main-controls">
					<Button variant="icon" onclick={stop} color={playState === PLAYSTATE_PLAYING || playState === PLAYSTATE_PAUSED ? 'delete' : 'primary'}>
						<StopIcon />
					</Button>

					<Button variant="icon" onclick={togglePlayPause} color="success">
						{#if playState === PLAYSTATE_PLAYING}
							<PauseIcon />
						{:else}
							<PlayIcon />
						{/if}
					</Button>

					<Button variant="icon" onclick={startRecording} color={playState === PLAYSTATE_RECORDING ? 'delete' : 'primary'}>
						<RecordIcon />
					</Button>
				</div>
			</div>

			<div class="song-progress">
				<div class="progress-group">
					<div class="progress-label">
						<span>Song Progress</span>
						<span class="time-display">{formatTime(currentSongTime)} / {formatTime(totalSongDuration)}</span>
					</div>
					<div class="progress-bar-container">
						<div class="progress-bar">
							<div class="progress-fill" style="width: {songProgress}%"></div>
							<div class="progress-handle" style="left: {songProgress}%"></div>
						</div>
					</div>
					<div class="remaining-time">-{formatTime(remainingSongTime)}</div>
				</div>
			</div>
		</div>

		<!-- Set Progress -->
		<div class="set-section">
			<div class="set-progress">
				<div class="progress-group">
					<div class="progress-label">
						<span>Set Progress</span>
						<span class="time-display">{formatTime(totalSetTime)} / {formatTime(totalSetDuration)}</span>
					</div>
					<div class="progress-bar-container">
						<div class="progress-bar set-progress-bar">
							<div class="progress-fill" style="width: {setProgress}%"></div>
							<div class="progress-handle" style="left: {setProgress}%"></div>
						</div>
					</div>
					<div class="remaining-time">-{formatTime(remainingSetTime)}</div>
				</div>
			</div>
		</div>

		<!-- Song Markers -->
		<div class="markers-section">
			<h3>Song Markers</h3>
			<div class="markers-grid">
				<button class="marker-button" onclick={() => goToStart()}>
					<div class="marker-name">Start</div>
					<div class="marker-time">{formatTime(0)}</div>
				</button>
				{#each songMarkers as marker (marker.id)}
					<button class="marker-button" onclick={() => goToMarker(marker)}>
						<div class="marker-name">{marker.name}</div>
						<div class="marker-time">{formatTime(marker.position)}</div>
					</button>
				{/each}
			</div>
		</div>
	{:else}
		<div class="no-setlist">
			<h2>No Setlist Loaded</h2>
			<p>Please load a setlist to begin playing.</p>
			<Button elementType="a" href="#/" color="primary">Browse Setlists</Button>
		</div>
	{/if}
</div>

<style>
	.track-navigation {
		display: flex;
		gap: 1rem;
		align-items: center;
	}

	.next-up-info {
		width: 100%;
		padding-top: 1rem;
		border-top: 1px solid var(--current-line);
	}

	.next-up-header {
		display: flex;
		justify-content: space-between;
		align-items: flex-start;
	}

	.next-up-info h4 {
		margin: 0;
		font-size: 1rem;
		font-weight: 600;
		color: var(--foreground);
	}

	.next-song {
		display: flex;
		flex-direction: column;
		align-items: flex-end;
		gap: 0.25rem;
		text-align: right;
	}

	.player-container {
		margin: 0 auto;
		padding: 2rem;
		display: flex;
		flex-direction: column;
		gap: 2rem;
		width: 100%;
		box-sizing: border-box;
	}

	.current-song-section {
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		align-items: center;
		gap: 2rem;
		padding: 2rem;
		background: var(--background);
		border-radius: 1rem;
		border: 2px solid var(--current-line);
	}

	.song-info {
		flex: 1;
		text-align: center;
	}

	.song-title {
		margin: 0.5rem 0 0 0;
		font-size: 2.5rem;
		font-weight: 700;
		color: var(--primary);
	}

	.song-meta {
		display: flex;
		flex-direction: column;
		align-items: center;
		gap: 0.25rem;
		color: var(--comment);
		font-size: 1rem;
		margin-bottom: 0;
	}

	:global(.track-nav-button) {
		flex-shrink: 0;
	}

	.progress-group {
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
	}

	.progress-label {
		display: flex;
		justify-content: space-between;
		align-items: center;
		font-weight: 600;
		color: var(--foreground);
	}

	.time-display {
		font-family: monospace;
		font-size: 1.1rem;
	}

	.progress-bar-container {
		padding: 0.5rem 0;
	}

	.progress-bar {
		position: relative;
		height: 8px;
		background: var(--current-line);
		border-radius: 4px;
		overflow: hidden;
	}

	.progress-fill {
		height: 100%;
		background: linear-gradient(90deg, var(--green), var(--cyan));
		border-radius: 4px;
		transition: width 0.3s ease;
	}

	.set-progress-bar .progress-fill {
		background: linear-gradient(90deg, var(--purple), var(--pink));
	}

	.progress-handle {
		position: absolute;
		top: 50%;
		transform: translate(-50%, -50%);
		width: 16px;
		height: 16px;
		background: var(--foreground);
		border-radius: 50%;
		border: 2px solid var(--background);
		transition: left 0.3s ease;
	}

	.remaining-time {
		text-align: right;
		color: var(--comment);
		font-family: monospace;
		font-size: 0.9rem;
	}

	.markers-section {
		background: var(--background);
		border-radius: 0.75rem;
		border: 1px solid var(--current-line);
		padding: 1.5rem;
	}

	.markers-section h3 {
		margin: 0 0 1rem 0;
		color: var(--foreground);
	}

	.markers-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
		gap: 0.75rem;
	}

	.marker-button {
		padding: 0.75rem;
		background: var(--current-line);
		border: 1px solid var(--comment);
		border-radius: 0.5rem;
		cursor: pointer;
		transition: all 0.2s ease;
		color: var(--foreground);
	}

	.marker-button:hover {
		background: var(--selection);
		border-color: var(--primary);
	}

	.marker-name {
		font-weight: 600;
		margin-bottom: 0.25rem;
	}

	.marker-time {
		font-size: 0.875rem;
		color: var(--comment);
		font-family: monospace;
	}

	.transport-section {
		background: var(--background);
		border-radius: 1rem;
		border: 2px solid var(--current-line);
		padding: 2rem;
		display: flex;
		flex-direction: column;
		gap: 2rem;
	}

	.transport-controls {
		display: flex;
		justify-content: center;
	}

	.set-section {
		background: var(--background);
		border-radius: 0.75rem;
		border: 1px solid var(--current-line);
		padding: 1.5rem;
		display: flex;
		flex-direction: column;
		gap: 1.5rem;
	}

	.main-controls {
		display: flex;
		align-items: center;
		gap: 1rem;
	}

	:global(.play-pause-button) {
		transform: scale(1.5);
	}

	:global(.record-button) {
		margin-left: 1rem;
	}

	.next-song-name {
		font-weight: 600;
		color: var(--foreground);
	}

	.next-song-duration {
		color: var(--comment);
		font-family: monospace;
	}

	.set-complete {
		color: var(--green);
		font-weight: 600;
		text-align: center;
		padding: 1rem;
	}

	.no-setlist {
		text-align: center;
		padding: 4rem 2rem;
		background: var(--background);
		border-radius: 1rem;
		border: 2px dashed var(--current-line);
	}

	.no-setlist h2 {
		margin: 0 0 1rem 0;
		color: var(--comment);
	}

	.no-setlist p {
		margin: 0 0 2rem 0;
		color: var(--comment);
	}

	/* Responsive Design */
	@media (max-width: 768px) {
		.player-container {
			padding: 1rem;
			gap: 1rem;
		}

		.current-song-section {
			padding: 1.5rem;
			gap: 1rem;
		}

		.song-info {
			text-align: center;
		}

		.next-up-info {
			padding-top: 0.75rem;
		}

		.song-title {
			font-size: 1.75rem;
			margin: 0.25rem 0 0 0;
		}

		.transport-section {
			padding: 1.5rem;
			gap: 1.5rem;
		}

		.set-section {
			gap: 1rem;
		}

		.markers-grid {
			grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
		}

		.main-controls {
			gap: 0.75rem;
		}

		:global(.play-pause-button) {
			transform: scale(1.3);
		}
	}
</style>
