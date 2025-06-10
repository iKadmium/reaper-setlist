<script lang="ts">
	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import Button from '$lib/components/Button/Button.svelte';
	import type { Database } from '$lib/models/database';
	import type { Setlist } from '$lib/models/setlist';
	import type { Song } from '$lib/models/song';
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
	let currentSetlist = $state<Setlist | null>(null);
	let allSongs = $state<Database<Song>>({});
	let currentSongIndex = $state<number>(0);
	let isPlaying = $state<boolean>(false);
	let isPaused = $state<boolean>(false);
	let isRecording = $state<boolean>(false);
	let currentSongTime = $state<number>(0);
	let totalSetTime = $state<number>(0);
	let playbackPosition = $state<number>(0);
	let bpm = $state<number>(120);
	let showMetronome = $state<boolean>(false);

	// Current song data
	const currentSong = $derived(
		!currentSetlist || currentSongIndex < 0 || currentSongIndex >= currentSetlist.songs.length ? null : allSongs[currentSetlist.songs[currentSongIndex]] || null
	);

	// Song markers (placeholder data - would come from Reaper)
	let songMarkers = $state([
		{ name: 'Intro', time: 0 },
		{ name: 'Verse 1', time: 15 },
		{ name: 'Chorus 1', time: 45 },
		{ name: 'Verse 2', time: 75 },
		{ name: 'Chorus 2', time: 105 },
		{ name: 'Bridge', time: 135 },
		{ name: 'Final Chorus', time: 165 },
		{ name: 'Outro', time: 195 }
	]);

	// Time calculations
	const totalSongDuration = $derived(currentSong?.length || 0);
	const remainingSongTime = $derived(Math.max(0, totalSongDuration - currentSongTime));
	const totalSetDuration = $derived(
		!currentSetlist
			? 0
			: currentSetlist.songs.reduce((total, songId) => {
					return total + (allSongs[songId]?.length || 0);
				}, 0)
	);
	const remainingSetTime = $derived(
		!currentSetlist
			? 0
			: (() => {
					let remaining = 0;
					for (let i = currentSongIndex; i < currentSetlist.songs.length; i++) {
						const songId = currentSetlist.songs[i];
						const songDuration = allSongs[songId]?.length || 0;
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
			if (isPlaying) {
				// Pause functionality would go here
				isPlaying = false;
				isPaused = true;
			} else {
				// Play functionality would go here
				isPlaying = true;
				isPaused = false;
			}
		} catch (error) {
			notifications.error(`Failed to toggle playback: ${(error as Error).message}`);
		}
	}

	async function stop() {
		try {
			// Stop functionality would go here
			isPlaying = false;
			isPaused = false;
			currentSongTime = 0;
			playbackPosition = 0;
		} catch (error) {
			notifications.error(`Failed to stop playback: ${(error as Error).message}`);
		}
	}

	async function previousTrack() {
		if (currentSongIndex > 0) {
			currentSongIndex--;
			currentSongTime = 0;
			// Load previous song logic would go here
		}
	}

	async function nextTrack() {
		if (currentSetlist && currentSongIndex < currentSetlist.songs.length - 1) {
			currentSongIndex++;
			currentSongTime = 0;
			// Load next song logic would go here
		}
	}

	async function goToMarker(markerTime: number) {
		try {
			currentSongTime = markerTime;
			playbackPosition = markerTime;
			// Seek to marker functionality would go here
			await api.reaper.goToStart(); // Placeholder - would seek to specific time
		} catch (error) {
			notifications.error(`Failed to jump to marker: ${(error as Error).message}`);
		}
	}

	async function startRecording() {
		try {
			isRecording = !isRecording;
			if (isRecording) {
				notifications.success('Recording started');
			} else {
				notifications.success('Recording stopped');
			}
		} catch (error) {
			notifications.error(`Failed to toggle recording: ${(error as Error).message}`);
		}
	}

	// Load sample data (in real app, this would come from route params)
	onMount(async () => {
		try {
			// Load songs and setlists
			const [songsData, setsData] = await Promise.all([api.songs.list(), api.sets.list()]);

			allSongs = songsData;

			// Use first setlist as example
			const setlists = Object.values(setsData);
			if (setlists.length > 0) {
				currentSetlist = setlists[0];
				notifications.success(`Loaded setlist: ${currentSetlist.venue}`);
			}
		} catch (error) {
			notifications.error(`Failed to load data: ${(error as Error).message}`);
		}
	});

	// Cleanup
	onDestroy(() => {
		// Clear any intervals or cleanup
	});
</script>

<meta:head>
	<title>Player - Reaper Setlist</title>
</meta:head>

<div class="player-container">
	<h1>Live Player</h1>

	{#if currentSetlist && currentSong}
		<!-- Current Song Display -->
		<div class="current-song-section">
			<div class="song-info">
				<h2 class="song-title">{currentSong.name}</h2>
				<div class="song-meta">
					<span class="song-number">Track {currentSongIndex + 1} of {currentSetlist.songs.length}</span>
					<span class="setlist-info">{currentSetlist.venue} • {new Date(currentSetlist.date).toLocaleDateString()}</span>
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

				<Button variant="icon" onclick={stop} color={isPlaying || isPaused ? 'delete' : 'primary'}>
					<StopIcon />
				</Button>

				<Button variant="icon" onclick={togglePlayPause} color="success">
					{#if isPlaying}
						<PauseIcon />
					{:else}
						<PlayIcon />
					{/if}
				</Button>

				<Button variant="icon" onclick={nextTrack} disabled={!currentSetlist || currentSongIndex >= currentSetlist.songs.length - 1}>
					<SkipNextIcon />
				</Button>

				<Button variant="icon" onclick={startRecording} color={isRecording ? 'delete' : 'primary'}>
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
			{#if currentSongIndex < currentSetlist.songs.length - 1}
				{@const nextSongId = currentSetlist.songs[currentSongIndex + 1]}
				{@const nextSong = allSongs[nextSongId]}
				{#if nextSong}
					<div class="next-song">
						<div class="next-song-name">{nextSong.name}</div>
						<div class="next-song-duration">{formatDuration(nextSong.length)}</div>
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
						<button class="marker-button" onclick={() => goToMarker(marker.time)}>
							<div class="marker-name">{marker.name}</div>
							<div class="marker-time">{formatTime(marker.time)}</div>
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
