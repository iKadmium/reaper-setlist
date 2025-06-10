<script lang="ts" module>
	type SongLike = Song | NewSong;

	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import Button from '$lib/components/Button/Button.svelte';
	import type { Database } from '$lib/models/database';
	import type { NewSong, Song } from '$lib/models/song';

	export interface SongEditorProps<T extends SongLike> {
		song: T;
		songs: Database<Song>;
		projects: string[];
		onSubmit: (song: T) => void;
	}
</script>

<script lang="ts">
	import Form from '../Form/Form.svelte';

	const api = getApi();

	type T = $$Generic<SongLike>;
	let { song: originalSong, onSubmit, projects, songs }: SongEditorProps<T> = $props();
	const song = $state({ ...originalSong });
	const duration = $derived(getDuration(song.length));

	// State for hiding projects that exist in other songs
	let hideUsedProjects = $state(true);

	// Get projects that are already used by other songs (excluding current song if editing)
	const usedProjects = $derived(
		Object.values(songs)
			.filter((s) => s.id !== song.id) // Exclude current song when editing
			.map((s) => s.path)
	);

	// Filter projects based on checkbox state
	const filteredProjects = $derived(hideUsedProjects ? projects.filter((project) => !usedProjects.includes(project)) : projects);

	function getDuration(length: number) {
		const minutes = Math.floor(length / 60);
		const seconds = length % 60;
		return `${minutes}:${seconds.toString().padStart(2, '0')}`;
	}

	function handleProjectSelect(projectPath: string) {
		song.path = projectPath;

		// Extract filename from path and remove extension for song name
		const pathSegments = projectPath.split(/[/\\]/);
		const filename = pathSegments[pathSegments.length - 1];
		const nameWithoutExtension = filename.replace(/\.[^/.]+$/, '');
		song.name = nameWithoutExtension;
	}

	async function handleGetDurationClick() {
		song.length = Math.ceil(await api.script.getProjectLength());
		notifications.success('Duration retrieved from Reaper!');
	}

	async function handleLoadClick() {
		try {
			await api.script.openProject(song.path);
			notifications.success(`${song.name} loaded in Reaper!`);
		} catch (error) {
			notifications.error(`Failed to load song in Reaper: ${(error as Error).message}`);
		}
	}
</script>

<Form onsubmit={() => onSubmit(song)}>
	<div class="form-group">
		<label for="relative-path">Project File:</label>
		<div class="input-with-select">
			<select onchange={(e) => handleProjectSelect(e.currentTarget.value)} bind:value={song.path} id="relative-path" required>
				<option value="">Select project...</option>
				{#each filteredProjects as project}
					<option value={project}>{project}</option>
				{/each}
			</select>
			<Button elementType="button" onclick={handleLoadClick} disabled={song.name === '' || song.path === ''}>Load</Button>
		</div>
		<div class="checkbox-container">
			<label class="checkbox-label">
				<input type="checkbox" bind:checked={hideUsedProjects} />
				Hide projects already used by other songs
			</label>
		</div>
	</div>

	<div class="form-group">
		<label for="song-name">Song Name:</label>
		<input bind:value={song.name} type="text" id="song-name" placeholder="Enter song name" required />
	</div>

	<div class="form-group">
		<label for="duration">Duration (seconds):</label>
		<div class="input-with-button">
			<input bind:value={song.length} type="number" id="duration" placeholder="Duration in seconds" min="0" required />
			<Button elementType="button" onclick={handleGetDurationClick}>Get from Reaper</Button>
		</div>
		<span class="duration-display">{duration}</span>
	</div>

	<div class="submit-section">
		<Button elementType="submit" disabled={song.name === '' || song.path === ''}>Save</Button>
	</div>
</Form>

<style>
	.duration-display {
		font-size: 0.875rem;
		color: var(--comment);
		font-style: italic;
		margin-top: 0.5rem;
	}

	.checkbox-container {
		margin-top: 0.5rem;
	}

	.checkbox-label {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		font-size: 0.875rem;
		color: var(--comment);
		cursor: pointer;
		font-weight: normal;
	}

	.checkbox-label input[type='checkbox'] {
		cursor: pointer;
		width: auto;
		margin: 0;
	}
</style>
