<script lang="ts" module>
	type SongLike = Song | NewSong;

	import Button from '$lib/components/Button/Button.svelte';
	import BrowseIcon from 'virtual:icons/mdi/folder-open';
	import LoadIcon from 'virtual:icons/mdi/file-upload';
	import GetDurationIcon from 'virtual:icons/mdi/timer-refresh-outline';
	import SaveIcon from 'virtual:icons/mdi/content-save';
	import { notifications } from '$lib';
	import type { NewSong, Song } from '$lib/models/song';

	export interface SongEditorProps<T extends SongLike> {
		song: T;
		onSubmit: (song: T) => void;
	}
</script>

<script lang="ts">
	type T = $$Generic<SongLike>;
	let { song: originalSong, onSubmit }: SongEditorProps<T> = $props();
	const song = $state({ ...originalSong });
	const duration = $derived(getDuration(song.length));

	function getDuration(length: number) {
		const minutes = Math.floor(length / 60);
		const seconds = length % 60;
		return `${minutes}:${seconds.toString().padStart(2, '0')}`;
	}

	async function handleBrowseClick() {
		const input = document.createElement('input');
		input.type = 'file';
		input.onchange = (e) => {
			const target = e.target as HTMLInputElement;
			const file = target.files?.[0];
			if (file) {
				song.name = file.name.replace(/\.[^/.]+$/, '');
			}
		};
		input.click();
	}

	async function handleGetDurationClick() {
		const response = await fetch('/api/reaper-project/current/get-duration', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			}
		});
		if (!response.ok) {
			notifications.error('Failed to get duration from Reaper');
			return;
		}
		const data = (await response.json()) as number;
		song.length = data;
		notifications.success('Duration retrieved from Reaper!');
	}

	async function handleLoadClick() {
		const response = await fetch(`/api/songs/load`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({ relative_path: song.relativePath })
		});
		if (!response.ok) {
			notifications.error(`Failed to load ${song.name} in Reaper`);
			return;
		}
		notifications.success(`${song.name} loaded in Reaper!`);
	}
</script>

<form onsubmit={() => onSubmit(song)}>
	<div class="form-fields">
		<div class="field">
			<label for="song-name">Song Name:</label>
			<input bind:value={song.name} type="text" id="song-name" placeholder="Enter song name" required />
		</div>

		<div class="field">
			<label for="relative-path">Project File Path (relative to root folder):</label>
			<input bind:value={song.relativePath} type="text" id="relative-path" placeholder="e.g., songs/song1.rpp" required />
		</div>

		<div class="field">
			<label for="duration">Duration (seconds):</label>
			<input bind:value={song.length} type="number" id="duration" placeholder="Duration in seconds" min="0" required />
			<span class="duration-display">{duration}</span>
		</div>
	</div>

	<div class="actions">
		<Button elementType="button" onclick={handleBrowseClick}><BrowseIcon /></Button>
		<Button elementType="button" onclick={handleLoadClick} disabled={song.name === '' || song.relativePath === ''}><LoadIcon /></Button>
		<Button elementType="button" onclick={handleGetDurationClick}><GetDurationIcon /></Button>
	</div>

	<Button elementType="submit" disabled={song.name === '' || song.relativePath === ''}><SaveIcon /></Button>
</form>

<style>
	.form-fields {
		display: flex;
		flex-direction: column;
		gap: 1rem;
		width: 100%;
		max-width: 500px;
	}

	.field {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.field label {
		font-weight: 600;
		color: var(--text);
	}

	.field input {
		padding: 0.5rem;
		border: 1px solid var(--border);
		border-radius: 0.25rem;
		background-color: var(--background);
		color: var(--text);
	}

	.duration-display {
		font-size: 0.875rem;
		color: var(--text-muted);
		font-style: italic;
	}

	.actions {
		display: flex;
		gap: 1rem;
		margin-top: 1rem;
	}

	form {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		align-items: flex-start;
	}
</style>
