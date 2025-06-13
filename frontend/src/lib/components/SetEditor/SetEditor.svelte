<script lang="ts" module>
	type SetlistLike = Setlist | NewSetlist;

	export interface SetEditorProps<T extends SetlistLike> {
		setlist: T;
		songs: Database<Song>;
		onSubmit: (setlist: T) => void;
	}
</script>

<script lang="ts">
	import { flip } from 'svelte/animate';
	import { fade, fly } from 'svelte/transition';
	import Button from '../Button/Button.svelte';
	import Form from '../Form/Form.svelte';

	import type { Database } from '$lib/models/database';
	import type { NewSetlist, Setlist } from '$lib/models/setlist';
	import type { Song } from '$lib/models/song';
	import { formatDuration } from '$lib/util';
	import DeleteIcon from 'virtual:icons/mdi/delete';
	import Draggable from '../Draggable/Draggable.svelte';

	// eslint-disable-next-line no-undef
	type T = $$Generic<SetlistLike>;

	let { setlist: initialSetlist, songs, onSubmit }: SetEditorProps<T> = $props();

	let setlist = $state({ ...initialSetlist });

	let remainingSongs = $derived(
		Object.values(songs)
			.filter((s) => !setlist.songs.includes(s.id))
			.toSorted((a, b) => a.name.localeCompare(b.name))
	);

	let newSongId = $state<string | null>(remainingSongs[0]?.id || null);
	let totalTime = $derived(setlist.songs.reduce((acc, songId) => acc + (songs[songId]?.length ?? 0) || 0, 0));

	let draggingIndex: number | undefined = $state(undefined);
	let draggingTargetIndex: number | undefined = $state(undefined);
	let itemsRef: HTMLDivElement | undefined = $state(undefined);

	function addSongToSetlist() {
		if (!newSongId || !songs[newSongId]) return;
		const song = songs[newSongId];
		if (song) {
			setlist.songs.push(song.id);
			newSongId = remainingSongs[0]?.id || null;
		}
	}

	function getMiddle(element: HTMLElement) {
		const rect = element.getBoundingClientRect();
		return rect.top + rect.height / 2;
	}

	function onDragMove(y: number) {
		if (!itemsRef) return;
		const childElements = Array.from(itemsRef.querySelectorAll<HTMLDivElement>('.list-item'));

		const closest = childElements.reduce((prev, curr) => (Math.abs(getMiddle(curr) - y) < Math.abs(getMiddle(prev) - y) ? curr : prev));
		if (y < getMiddle(closest)) {
			draggingTargetIndex = childElements.indexOf(closest);
		} else {
			draggingTargetIndex = childElements.indexOf(closest) + 1;
		}
	}

	function onDragStart(index: number) {
		draggingIndex = index;
	}

	function onDragEnd() {
		if (draggingIndex !== undefined && draggingTargetIndex !== undefined) {
			const removedItem = setlist.songs.splice(draggingIndex, 1)[0];
			const adjustedIndex = draggingTargetIndex > draggingIndex ? draggingTargetIndex - 1 : draggingTargetIndex;
			setlist.songs.splice(adjustedIndex, 0, removedItem);
		}
		draggingIndex = undefined;
		draggingTargetIndex = undefined;
	}
</script>

<Form onsubmit={() => onSubmit(setlist)}>
	<div class="form-group">
		<label for="venue">Venue:</label>
		<input type="text" id="venue" bind:value={setlist.venue} placeholder="Enter venue name" required />
	</div>

	<div class="form-group">
		<label for="date">Date:</label>
		<input
			type="date"
			id="date"
			value={new Date(setlist.date).toISOString().split('T')[0]}
			onchange={({ currentTarget: { value: v } }) => (setlist.date = v ? new Date(v).toISOString() : new Date().toISOString())}
			required
		/>
	</div>

	<div class="songs-container">
		<h2>Songs</h2>
		<dl>
			<dt>Total time:</dt>
			<dd>{formatDuration(totalTime)}</dd>
		</dl>
		<div class="items" bind:this={itemsRef}>
			{#each setlist.songs as songId, i (i)}
				<div class="item-container" animate:flip={{ duration: 300 }} transition:fly={{ duration: 300 }}>
					{#if draggingTargetIndex === i}
						<div class="drag-target" in:fade={{ duration: 200 }}></div>
					{/if}
					<div class="list-item" class:dragging={draggingIndex === i}>
						<Draggable onmove={(y) => onDragMove(y, i)} onstart={() => onDragStart(i)} onend={() => onDragEnd()} />
						<div class="song-info">
							<span class="song-name">{songs[songId]?.name}</span>
							<span class="song-duration">{formatDuration(songs[songId]?.length || 0)}</span>
						</div>
						<Button color="delete" onclick={() => setlist.songs.splice(i, 1)} variant="icon"><DeleteIcon /></Button>
					</div>
				</div>
			{/each}
			{#if draggingTargetIndex === setlist.songs.length}
				<div class="drag-target"></div>
			{/if}
		</div>
	</div>

	{#if remainingSongs.length > 0}
		<div class="form-group">
			<label for="new-song">Add Song:</label>
			<div class="add-song-container input-with-button">
				<select id="new-song" bind:value={newSongId}>
					{#each remainingSongs as song (song.id)}
						<option value={song.id}>{song.name}</option>
					{/each}
				</select>
				<Button elementType="button" onclick={addSongToSetlist} disabled={newSongId === null}>Add</Button>
			</div>
		</div>
	{:else}
		<p>No songs left to add</p>
	{/if}

	<div class="submit-section">
		<Button elementType="submit">Save</Button>
	</div>
</Form>

<style>
	.add-song-container {
		display: flex;
		gap: 0.5rem;
		align-items: center;
	}

	.add-song-container select {
		flex: 1;
	}

	.songs-container {
		margin-top: 1rem;
	}

	.songs-container h2 {
		margin-bottom: 1rem;
		font-size: 1.25rem;
		color: var(--foreground);
	}

	.songs-container dl {
		margin: 0 0 1rem 0;
		padding: 0;
		display: flex;
		gap: 1rem;
		align-items: center;
	}

	.songs-container dt {
		font-weight: 500;
		color: var(--foreground);
		margin: 0;
	}

	.songs-container dd {
		margin: 0;
		color: var(--foreground);
		font-family: monospace;
		font-weight: 600;
		font-size: 1.1rem;
	}

	.items {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		margin-bottom: 1rem;
	}

	.list-item {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		padding: 0.75rem;
		background: var(--current-line);
		border-radius: 0.5rem;
		border: 1px solid transparent;
		transition: border-color 0.2s ease;
	}

	.song-name {
		color: var(--foreground);
		font-weight: 500;
	}

	.song-info {
		flex-grow: 1;
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.song-duration {
		color: var(--comment);
		font-family: monospace;
		font-size: 0.875rem;
	}

	.dragging {
		background-color: var(--black);
		border-color: var(--orange);
	}

	.drag-target {
		height: 3px;
		background-color: var(--orange);
		width: 100%;
		border-radius: 1.5px;
		margin: 0.25rem 0;
	}
</style>
