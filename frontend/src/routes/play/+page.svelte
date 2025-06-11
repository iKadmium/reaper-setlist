<script lang="ts">
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import { type PlayState, PLAYSTATE_PAUSED, PLAYSTATE_PLAYING, PLAYSTATE_RECORDING, PLAYSTATE_STOPPED } from '$lib/api/reaper-backend/reaper-api';
	import Button from '$lib/components/Button/Button.svelte';
	import type { ReaperMarker } from '$lib/models/reaper-marker';
	import type { ReaperTab } from '$lib/models/reaper-tab';
	import { formatDuration } from '$lib/util';
	import { onDestroy, onMount } from 'svelte';
	// Icons
	import MetronomeIcon from 'virtual:icons/mdi/metronome';
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
	let totalSetTime = $state<number>(0);
	let bpm = $state<number>(120);
	let transportUpdateHandle = $state<number | null>(null);

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

	// Player controls
	async function togglePlayPause() {
		try {
			if (playState === PLAYSTATE_PLAYING) {
				await api.reaper.pause();
				await updateTransport();
			} else if (playState === PLAYSTATE_PAUSED || playState === PLAYSTATE_STOPPED) {
				await api.reaper.play();
				await updateTransport();
			}
		} catch (error) {
			notifications.error(`Failed to toggle playback: ${(error as Error).message}`);
		}
	}

	async function stop() {
		try {
			await api.reaper.stop();
			await updateTransport();
		} catch (error) {
			notifications.error(`Failed to stop playback: ${(error as Error).message}`);
		}
	}

	async function previousTrack() {
		if (currentSongIndex > 0) {
			currentSongIndex--;
			await api.reaper.previousTab();
			await updateSong();
			await updateTransport();
		}
	}

	async function nextTrack() {
		if (allTabs && currentSongIndex < allTabs.length - 1) {
			currentSongIndex++;
			await api.reaper.nextTab();
			await updateSong();
			await updateTransport();
		}
	}

	async function goToMarker(marker: ReaperMarker) {
		try {
			await api.reaper.goToMarker(marker.id);
			await updateTransport();
		} catch (error) {
			notifications.error(`Failed to jump to marker: ${(error as Error).message}`);
		}
	}

	async function startRecording() {
		try {
			await api.reaper.record();
			await updateTransport();
		} catch (error) {
			notifications.error(`Failed to toggle recording: ${(error as Error).message}`);
		}
	}

	async function updateTransport() {
		try {
			const state = await api.reaper.getTransport();
			playState = state.playState;
			currentSongTime = state.positionSeconds;
		} catch (error) {
			console.error(`Failed to update transport: ${(error as Error).message}`);
		}
	}

	async function updateSong() {
		try {
			songMarkers = await api.reaper.getMarkers();
		} catch (error) {
			notifications.error(`Failed to load markers: ${(error as Error).message}`);
		}
	}

	// Load sample data (in real app, this would come from route params)
	onMount(async () => {
		try {
			allTabs = await api.script.getOpenTabs();
			transportUpdateHandle = window.setInterval(updateTransport, 1000); // Update transport every second
			await updateSong(); // Load initial song markers
		} catch (error) {
			notifications.error(`Failed to load data: ${(error as Error).message}`);
		}
	});

	// Cleanup
	onDestroy(() => {
		if (transportUpdateHandle) {
			window.clearInterval(transportUpdateHandle);
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
				<h2 class="song-title">{currentTab.name}</h2>
				<div class="song-meta">
					<span class="song-number">Track {currentSongIndex + 1} of {allTabs.length}</span>
				</div>
			</div>

			<!-- Tempo and Volume -->
			<div class="tempo-volume">
				<div class="tempo-display">
					<MetronomeIcon />
					<span>{bpm} BPM</span>
				</div>
			</div>
		</div>

		<!-- Transport Controls -->
		<div class="transport-controls">
			<div class="main-controls">
				<Button variant="icon" onclick={previousTrack} disabled={currentSongIndex === 0}>
					<SkipPreviousIcon />
				</Button>

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

				<Button variant="icon" onclick={nextTrack} disabled={!allTabs || currentSongIndex >= allTabs.length - 1}>
					<SkipNextIcon />
				</Button>

				<Button variant="icon" onclick={startRecording} color={playState === PLAYSTATE_RECORDING ? 'delete' : 'primary'}>
					<RecordIcon />
				</Button>
			</div>
		</div>

		<!-- Song Progress -->
		<div class="progress-section">
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

		<!-- Additional Live Performance Features -->
		<div class="live-features">
			<h4>Next Up</h4>
			{#if currentSongIndex < allTabs.length - 1}
				{@const nextTab = allTabs[currentSongIndex + 1]}
				{#if nextTab}
					<div class="next-song">
						<div class="next-song-name">{nextTab.name}</div>
						<div class="next-song-duration">{formatDuration(nextTab.length)}</div>
					</div>
				{/if}
			{:else}
				<div class="set-complete">Set Complete!</div>
			{/if}
		</div>

		<!-- Set Progress -->
		<div class="progress-section">
			<div class="progress-group">
				<div class="progress-label">
					<span>Set Progress</span>
					<span class="time-display">{formatTime(totalSetTime)} / {formatTime(totalSetDuration)}</span>
				</div>
				<div class="progress-bar-container">
					<div class="progress-bar set-progress">
						<div class="progress-fill" style="width: {setProgress}%"></div>
						<div class="progress-handle" style="left: {setProgress}%"></div>
					</div>
				</div>
				<div class="remaining-time">-{formatTime(remainingSetTime)}</div>
			</div>
		</div>

		<!-- Song Markers -->
		{#if songMarkers.length > 0}
			<div class="markers-section">
				<h3>Song Markers</h3>
				<div class="markers-grid">
					{#each songMarkers as marker}
						<button class="marker-button" onclick={() => goToMarker(marker)}>
							<div class="marker-name">{marker.name}</div>
							<div class="marker-time">{formatTime(marker.position)}</div>
						</button>
					{/each}
				</div>
			</div>
		{/if}
	{:else}
		<div class="no-setlist">
			<h2>No Setlist Loaded</h2>
			<p>Please load a setlist to begin playing.</p>
			<Button elementType="a" href="/" color="primary">Browse Setlists</Button>
		</div>
	{/if}
</div>

<style>
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
		justify-content: space-between;
		align-items: flex-start;
		gap: 2rem;
		padding: 2rem;
		background: var(--background);
		border-radius: 1rem;
		border: 2px solid var(--current-line);
	}

	.song-info {
		flex: 1;
	}

	.song-title {
		margin: 0 0 0.5rem 0;
		font-size: 2.5rem;
		font-weight: 700;
		color: var(--primary);
	}

	.song-meta {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		color: var(--comment);
		font-size: 1rem;
	}

	.tempo-volume {
		display: flex;
		flex-direction: column;
		gap: 1rem;
		align-items: flex-end;
		justify-content: flex-end;
		height: 100%;
	}

	.tempo-display {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		font-size: 1.25rem;
		font-weight: 600;
	}

	.progress-section {
		background: var(--background);
		border-radius: 0.75rem;
		border: 1px solid var(--current-line);
		padding: 1.5rem;
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
		cursor: pointer;
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

	.set-progress .progress-fill {
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
		cursor: pointer;
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

	.transport-controls {
		display: flex;
		justify-content: center;
		padding: 2rem;
		background: var(--background);
		border-radius: 1rem;
		border: 2px solid var(--current-line);
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

	.live-features {
		background: var(--background);
		border-radius: 0.75rem;
		border: 1px solid var(--current-line);
		padding: 1.5rem;
	}

	.next-song {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
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
			flex-direction: column;
			padding: 1.5rem;
		}

		.tempo-volume {
			flex-direction: row;
			justify-content: space-between;
			align-items: center;
			width: 100%;
		}

		.song-title {
			font-size: 2rem;
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
