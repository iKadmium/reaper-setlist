<script lang="ts" module>
	import Button from '$lib/components/Button/Button.svelte';
	import BrowseIcon from 'virtual:icons/mdi/folder-open';
	import LoadIcon from 'virtual:icons/mdi/file-upload';
	import GetDurationIcon from 'virtual:icons/mdi/timer-refresh-outline';
	import SaveIcon from 'virtual:icons/mdi/content-save';

	export interface SongEditorProps {
		song: SongInsert | Song;
		onSubmit: (song: SongInsert | Song) => void;
	}
</script>

<script lang="ts">
	let { song: originalSong, onSubmit }: SongEditorProps = $props();
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
		const data = (await response.json()) as GetDurationResponseBody;
		if (data.error) {
			console.error(data.error);
			return;
		} else if (data.duration) {
			song.length = data.duration;
		}
	}

	async function handleLoadClick() {
		const response = await fetch(`/api/reaper-project/${song.name}/load`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			}
		});
		const data = (await response.json()) as GetDurationResponseBody;
		if (data.error) {
			console.error(data.error);
			return;
		} else if (data.duration) {
			song.length = data.duration;
		}
	}
</script>

<form onsubmit={() => onSubmit(song)}>
	<table>
		<tbody>
			<tr>
				<th>Name</th>
				<td>{song.name || 'No name yet'}</td>
			</tr>
			<tr>
				<th>Duration</th>
				<td>{duration}</td>
			</tr>
		</tbody>
	</table>

	<div class="actions">
		<Button elementType="button" onclick={handleBrowseClick}><BrowseIcon /></Button>
		<Button elementType="button" onclick={handleLoadClick} disabled={song.name === ''}><LoadIcon /></Button>
		<Button elementType="button" onclick={handleGetDurationClick}><GetDurationIcon /></Button>
	</div>

	<Button elementType="submit"><SaveIcon /></Button>
</form>

<style>
	th {
		text-align: left;
		padding-right: 1rem;
	}

	.actions {
		display: flex;
		gap: 1rem;
	}

	form {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		align-items: flex-start;
	}
</style>
