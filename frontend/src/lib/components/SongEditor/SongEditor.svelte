<script lang="ts" module>
	type SongLike = Song | NewSong;

	import { notifications } from '$lib';
	import Button from '$lib/components/Button/Button.svelte';
	import type { Database } from '$lib/models/database';
	import type { NewSong, Song } from '$lib/models/song';
	import SaveIcon from 'virtual:icons/mdi/content-save';
	import LoadIcon from 'virtual:icons/mdi/file-upload';
	import GetDurationIcon from 'virtual:icons/mdi/timer-refresh-outline';

	export interface SongEditorProps<T extends SongLike> {
		song: T;
		songs: Database<Song>;
		projects: string[];
		onSubmit: (song: T) => void;
	}
</script>

<script lang="ts">
	import Form from '../Form/Form.svelte';

	type T = $$Generic<SongLike>;
	let { song: originalSong, onSubmit, projects }: SongEditorProps<T> = $props();
	const song = $state({ ...originalSong });
	const duration = $derived(getDuration(song.length));

	function getDuration(length: number) {
		const minutes = Math.floor(length / 60);
		const seconds = length % 60;
		return `${minutes}:${seconds.toString().padStart(2, '0')}`;
	}

	function handleProjectSelect(projectPath: string) {
		song.relativePath = projectPath;

		// Extract filename from path and remove extension for song name
		const pathSegments = projectPath.split(/[/\\]/);
		const filename = pathSegments[pathSegments.length - 1];
		const nameWithoutExtension = filename.replace(/\.[^/.]+$/, '');
		song.name = nameWithoutExtension;
	}

	async function handleGetDurationClick() {
		const response = await fetch('/api/projects/current/get-duration', {
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
		const response = await fetch(`/api/projects/load`, {
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

<Form onsubmit={() => onSubmit(song)}>
	<div class="form-fields">
		<div class="field">
			<label for="relative-path">Project File Path (relative to root folder):</label>
			<div class="input-with-select">
				<select onchange={(e) => handleProjectSelect(e.currentTarget.value)} bind:value={song.relativePath} id="relative-path" required>
					<option value="">Select project...</option>
					{#each projects as project}
						<option value={project}>{project}</option>
					{/each}
				</select>
				<Button elementType="button" onclick={handleLoadClick} disabled={song.name === '' || song.relativePath === ''}><LoadIcon /></Button>
			</div>
		</div>

		<div class="field">
			<label for="song-name">Song Name:</label>
			<input bind:value={song.name} type="text" id="song-name" placeholder="Enter song name" required />
		</div>

		<div class="field">
			<label for="duration">Duration (seconds):</label>
			<div class="input-with-button">
				<input bind:value={song.length} type="number" id="duration" placeholder="Duration in seconds" min="0" required />
				<Button elementType="button" onclick={handleGetDurationClick}><GetDurationIcon /></Button>
			</div>
			<span class="duration-display">{duration}</span>
		</div>
	</div>

	<div class="submit-section">
		<Button elementType="submit" disabled={song.name === '' || song.relativePath === ''}><SaveIcon /></Button>
	</div>
</Form>

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
		flex: 1;
	}

	.field select {
		padding: 0.5rem;
		border: 1px solid var(--border);
		border-radius: 0.25rem;
		background-color: var(--background);
		color: var(--text);
		flex: 1;
	}

	.input-with-select,
	.input-with-button {
		display: flex;
		gap: 0.5rem;
		align-items: center;
	}

	.duration-display {
		font-size: 0.875rem;
		color: var(--text-muted);
		font-style: italic;
	}
</style>
