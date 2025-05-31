<script lang="ts">
	import { page } from '$app/state';
	import Button from '$lib/components/Button/Button.svelte';
	import type { Database } from '$lib/models/database';
	import type { Setlist } from '$lib/models/setlist';
	import type { Song } from '$lib/models/song';
	import { onMount } from 'svelte';
	import LoadIcon from 'virtual:icons/mdi/playlist-play';

	let log = $state<LogItem[]>([]);
	let working = $state<boolean>(false);
	let set = $state<Setlist | undefined>(undefined);
	let songs = $state<Database<Song>>({});
	let loading = $state<boolean>(true);

	interface LogItem {
		time: Date;
		color: string;
		message: string;
	}

	onMount(async () => {
		try {
			const id = page.params.id;
			const setRes = await fetch(`/api/sets/${id}`);
			if (!setRes.ok) throw new Error('Failed to fetch set');
			set = await setRes.json();
			const songsRes = await fetch('/api/songs');
			if (!songsRes.ok) throw new Error('Failed to fetch songs');
			songs = await songsRes.json();
		} finally {
			loading = false;
		}
	});

	async function loadSong(songId: string, name: string): Promise<LogItem> {
		const res = await fetch(`/api/reaper-project/${name}/load`, { method: 'POST' });
		if (res.ok) {
			await res.json(); // wait for the operation to complete
			return { time: new Date(), message: `Loaded ${name}`, color: 'green' };
		}
		return { time: new Date(), message: 'Failed', color: 'red' };
	}

	async function newTab() {
		const res = await fetch(`/api/reaper-project/new-tab`, { method: 'POST' });
		if (res.ok) {
			await res.json(); // wait for the operation to complete
			return { time: new Date(), message: 'New tab opened', color: 'green' };
		}
		return { time: new Date(), message: 'Failed to open new tab', color: 'red' };
	}

	async function goToStart() {
		const res = await fetch(`/api/reaper-project/current/go-to-start`, { method: 'POST' });
		if (res.ok) {
			await res.json(); // wait for the operation to complete
			return { time: new Date(), message: 'Moved playhead to start', color: 'green' };
		}
		return { time: new Date(), message: 'Failed', color: 'red' };
	}

	async function loadSet() {
		if (!set || working) return;
		working = true;
		log.splice(0, log.length);
		try {
			for (const index in set.songs) {
				const songId = set.songs[index];

				const name = songs[songId]?.name;
				if (!name) {
					log.push({ time: new Date(), message: `Song ID ${songId} not found`, color: 'red' });
					continue;
				}

				if (index !== '0') {
					log.push({ time: new Date(), message: `Opening new tab`, color: 'foreground' });
					const newTabResult = await newTab();
					log.push(newTabResult);
				}

				log.push({ time: new Date(), message: `Loading ${name}`, color: 'foreground' });
				const loadSongResult = await loadSong(songId, name);
				log.push(loadSongResult);

				log.push({ time: new Date(), message: `Move the playhead to the start`, color: 'foreground' });
				const goToStartResult = await goToStart();
				log.push(goToStartResult);
			}
		} catch (e) {
			console.error(e);
		} finally {
			working = false;
		}
	}
</script>

<meta:head>
	<title>Load Set - Reaper Setlist</title>
</meta:head>

<h1>Load Set</h1>

<Button onclick={loadSet} disabled={working}><LoadIcon /></Button>

{#if loading}
	<p>Loading...</p>
{:else if log.length > 0}
	<ul class="list-group">
		{#each log as item}
			<li class="list-item" style={`background-color: var(--${item.color})`}>
				<span>{item.time.toLocaleTimeString()}</span>
				<span>{item.message}</span>
			</li>
		{/each}
	</ul>
{/if}

<style>
	.list-group {
		list-style: none;
		padding: 0;
		width: 100%;
		border-radius: 0.5rem;
		margin: 0;
		overflow: hidden;
	}

	.list-item {
		padding: 0.5rem;
		color: var(--background);
		display: flex;
		flex-direction: row;
		gap: 1rem;
	}
</style>
