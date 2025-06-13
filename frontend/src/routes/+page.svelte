<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import ItemGrid from '$lib/components/ItemGrid/ItemGrid.svelte';
	import ResponsiveActions from '$lib/components/ResponsiveActions/ResponsiveActions.svelte';

	import { notifications } from '$lib';
	import { getApi } from '$lib/api/api';
	import type { Database } from '$lib/models/database';
	import type { NewSetlist, Setlist } from '$lib/models/setlist';
	import { formatDuration } from '$lib/util';
	import { onMount } from 'svelte';
	import CopyIcon from 'virtual:icons/mdi/content-copy';
	import DeleteIcon from 'virtual:icons/mdi/delete';
	import EditIcon from 'virtual:icons/mdi/pencil';
	import PlayIcon from 'virtual:icons/mdi/play';
	import type { PageData } from './$types';

	let { data }: { data: PageData } = $props();

	const sets = $state<Database<Setlist>>(data.sets);
	const songs = data.songs;
	const errorMessage = data.error;
	const api = getApi();

	onMount(() => {
		if (errorMessage) {
			notifications.error(`Failed to load data: ${errorMessage}`);
		}
	});

	async function handleDeleteClick(item: Setlist) {
		if (confirm('Are you sure you want to delete this set?')) {
			try {
				// Call the API to delete the set
				await api.sets.delete(item.id);
				delete sets[item.id]; // Remove from local state
				notifications.success('Set deleted successfully');
			} catch (error) {
				notifications.error(`Failed to delete set: ${(error as Error).message}`);
			}
		}
	}

	async function handleDuplicateClick(item: Setlist) {
		const duplicated: NewSetlist = { ...item, id: undefined, venue: `${item.venue} (copy)` };
		try {
			const newSet = await api.sets.add(duplicated);
			sets[newSet.id] = newSet; // Or sets = [...sets, newSet] with Svelte 5 runes
			notifications.success('Set duplicated successfully');
		} catch (error) {
			notifications.error(`Failed to duplicate set: ${(error as Error).message}`);
		}
	}

	function sortFunction(a: Setlist, b: Setlist) {
		if (a.date !== b.date) {
			return new Date(a.date).getTime() - new Date(b.date).getTime();
		}
		if (a.venue !== b.venue) {
			return a.venue.localeCompare(b.venue);
		}
		return a.id.localeCompare(b.id);
	}

	function formatDate(dateString: string): string {
		const date = new Date(dateString);
		const currentYear = new Date().getFullYear();
		const dateYear = date.getFullYear();

		const options: Intl.DateTimeFormatOptions = {
			day: 'numeric',
			month: 'long'
		};

		// Only include year if it's different from current year
		if (dateYear !== currentYear) {
			options.year = 'numeric';
		}

		// Use user's locale, fallback to en-US
		const userLocale = navigator.language || 'en-US';
		return date.toLocaleDateString(userLocale, options);
	}
</script>

<meta:head>
	<title>Sets - Reaper Setlist</title>
</meta:head>

<h1>Sets</h1>

{#if errorMessage}
	<p style="color: red;">{errorMessage}</p>
{:else}
	<ItemGrid items={Object.values(sets).toSorted(sortFunction)}>
		{#snippet nameDisplay(item)}
			<div class="set-info">
				<div class="set-header">
					<span class="date">{formatDate(item.date)}</span>
					<span class="venue">{item.venue}</span>
				</div>
				<div class="set-details">
					<span class="song-count">{item.songs.length} song{item.songs.length > 1 ? 's' : ''}</span>
					<span class="duration">{formatDuration(item.songs.map((songId) => songs[songId]?.length || 0).reduce((a, b) => a + b, 0))}</span>
				</div>
			</div>
		{/snippet}
		{#snippet actions(item)}
			<ResponsiveActions>
				{#snippet primaryAction()}
					<Button color="primary" elementType="a" href={`#/set/${item.id}/load`} variant="icon"><PlayIcon /></Button>
				{/snippet}
				{#snippet secondaryActions()}
					<Button elementType="a" color="edit" href={`#/set/${item.id}/edit`} variant="icon"><EditIcon /></Button>
					<Button color="delete" onclick={() => handleDeleteClick(item)} variant="icon"><DeleteIcon /></Button>
					<Button color="success" onclick={() => handleDuplicateClick(item)} variant="icon"><CopyIcon /></Button>
				{/snippet}
			</ResponsiveActions>
		{/snippet}
	</ItemGrid>
{/if}

<div class="action-section">
	<Button elementType="a" href="#/set/add" color="success">Add Set</Button>
</div>

<style>
	.set-info {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.set-header {
		display: flex;
		flex-direction: column;
		gap: 0.125rem;
	}

	.date {
		font-weight: 600;
		color: var(--text);
		font-size: 1rem;
	}

	.venue {
		font-size: 1.1rem;
		color: var(--text);
		font-weight: 500;
	}

	.set-details {
		display: flex;
		gap: 1rem;
		font-size: 0.875rem;
		color: var(--text-muted);
	}

	.song-count {
		font-weight: 500;
	}

	.duration {
		font-weight: 400;
	}

	/* On mobile, allow venue names to wrap properly */
	@media (max-width: 768px) {
		.set-header {
			flex-direction: column;
			gap: 0.25rem;
		}

		.date {
			font-size: 0.875rem;
			font-weight: 500;
		}

		.venue {
			font-size: 1rem;
			word-wrap: break-word;
			overflow-wrap: break-word;
		}

		.set-details {
			gap: 0.75rem;
			font-size: 0.8rem;
		}
	}
</style>
