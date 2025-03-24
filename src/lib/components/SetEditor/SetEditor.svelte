<script lang="ts" module>
	export interface SetEditorProps {
		setlist: SetlistDenormalized;
		songs: Song[];
		onSubmit: (setlist: SetlistDenormalized) => void;
	}
</script>

<script lang="ts">
	import type { SetlistDenormalized, Song } from '$lib/server/db/schema';
	import { flip } from 'svelte/animate';
	import Button from '../Button/Button.svelte';
	import { fade, fly } from 'svelte/transition';

	import Draggable from '../Draggable/Draggable.svelte';
	import DeleteIcon from 'virtual:icons/mdi/delete';
	import AddIcon from 'virtual:icons/mdi/plus';
	import SaveIcon from 'virtual:icons/mdi/content-save';
	import { formatDuration } from '$lib/util';

	let { setlist: initialSetlist, songs, onSubmit }: SetEditorProps = $props();

	let setlist = $state(initialSetlist);
	let newSongId = $state<number | null>(songs[0]?.id || null);

	let remainingSongs = $derived(songs.filter((s) => !setlist.songs.includes(s.id)));
	let totalTime = $derived(setlist.songs.reduce((acc, songId) => acc + (songs.find((s) => s.id === songId)?.length ?? 0) || 0, 0));

	let draggingIndex: number | undefined = $state(undefined);
	let draggingTargetIndex: number | undefined = $state(undefined);
	let itemsRef: HTMLDivElement | undefined = $state(undefined);

	function addSongToSetlist() {
		const song = songs.find((s) => s.id === newSongId);
		if (song) {
			setlist.songs.push(song.id);
			newSongId = remainingSongs[0]?.id || null;
		}
	}

	function getMiddle(element: HTMLElement) {
		const rect = element.getBoundingClientRect();
		return rect.top + rect.height / 2;
	}

	function onDragMove(y: number, index: number) {
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

	function onDragEnd(y: number) {
		if (draggingIndex !== undefined && draggingTargetIndex !== undefined) {
			const removedItem = setlist.songs.splice(draggingIndex, 1)[0];
			const adjustedIndex = draggingTargetIndex > draggingIndex ? draggingTargetIndex - 1 : draggingTargetIndex;
			setlist.songs.splice(adjustedIndex, 0, removedItem);
		}
		draggingIndex = undefined;
		draggingTargetIndex = undefined;
	}
</script>

<div>
	<label>
		Venue:
		<input type="text" bind:value={setlist.venue} placeholder="Enter venue name" />
	</label>
	<label>
		Date:
		<input
			type="date"
			value={new Date(setlist.date).toISOString().split('T')[0]}
			onchange={({ currentTarget: { value: v } }) => (setlist.date = v ? new Date(v).getTime() : new Date().getTime())}
		/>
	</label>
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
					<Draggable onmove={(y) => onDragMove(y, i)} onstart={() => onDragStart(i)} onend={(y) => onDragEnd(y)} />
					<span class="song-name">{songs.find((s) => s.id === songId)?.name}</span>
					<Button color="delete" onclick={() => setlist.songs.splice(i, 1)}><DeleteIcon /></Button>
				</div>
			</div>
		{/each}
		{#if draggingTargetIndex === setlist.songs.length}
			<div class="drag-target"></div>
		{/if}
	</div>
</div>

{#if remainingSongs.length > 0}
	<div class="add-song-container">
		<select bind:value={newSongId}>
			{#each remainingSongs as song}
				<option value={song.id}>{song.name}</option>
			{/each}
		</select>
	</div>
	<Button elementType="button" onclick={addSongToSetlist} disabled={newSongId === null}><AddIcon /></Button>
{:else}
	<p>No songs left to add</p>
{/if}

<Button elementType="submit" onclick={() => onSubmit(setlist)}><SaveIcon /></Button>

<style>
	.add-song-container {
		display: flex;
		flex-direction: row;
		gap: 0.5rem;
		width: 100%;
	}

	.items {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.list-item {
		display: flex;
		align-items: center;
		gap: 0.5rem;
		border-radius: 0.5rem;
		border-width: 1px;
		border-style: solid;
		border-color: transparent;
	}

	.song-name {
		flex-grow: 1;
		padding-right: 2rem;
	}

	.dragging {
		background-color: var(--black);
		border-color: var(--orange);
	}

	.drag-target {
		height: 5px;
		background-color: var(--orange);
		width: 100%;
	}
</style>
