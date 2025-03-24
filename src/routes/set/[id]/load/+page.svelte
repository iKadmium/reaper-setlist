<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import type { PageProps } from './$types';

	import LoadIcon from 'virtual:icons/mdi/playlist-play';

	let { data }: PageProps = $props();

	interface LogItem {
		time: Date;
		color: string;
		message: string;
	}

	let log: LogItem[] = $state<LogItem[]>([]);
	let working = $state(false);

	async function loadSong(songId: number, name: string): Promise<LogItem> {
		const res = await fetch(`/api/reaper-project/${name}/load`, { method: 'POST' });
		await res.json(); // wait for the operation to complete
		return { time: new Date(), message: res.ok ? 'OK' : 'Failed', color: res.ok ? 'green' : 'red' };
	}

	async function newTab() {
		const res = await fetch(`/api/reaper-project/new-tab`, { method: 'POST' });
		await res.json(); // wait for the operation to complete
		return { time: new Date(), message: res.ok ? 'OK' : 'Failed', color: res.ok ? 'green' : 'red' };
	}

	async function goToStart() {
		const res = await fetch(`/api/reaper-project/current/go-to-start`, { method: 'POST' });
		await res.json(); // wait for the operation to complete
		return { time: new Date(), message: res.ok ? 'OK' : 'Failed', color: res.ok ? 'green' : 'red' };
	}

	async function loadSet() {
		working = true;
		log.splice(0, log.length);
		try {
			for (const index in data.set.songs) {
				const songId = data.set.songs[index];

				const name = data.songs.find((s) => s.id === songId)?.name;
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

{#if log.length > 0}
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
