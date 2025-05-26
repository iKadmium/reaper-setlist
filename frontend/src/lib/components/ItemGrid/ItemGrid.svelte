<script lang="ts" module>
	import type { Snippet } from 'svelte';

	export interface ItemGridProps<T> {
		items: T[];
		getName: (item: T) => string;
		actions: (item: T) => Snippet;
	}
</script>

<script lang="ts">
	type T = $$Generic;

	let { items, getName, actions }: ItemGridProps<T> = $props();
</script>

<div class="item-grid">
	{#each items as item}
		<div class="list-item">
			<span class="name">{getName(item)}</span>
			<div class="actions">
				{@render actions(item)}
			</div>
		</div>
	{/each}
</div>

<style>
	.actions {
		display: flex;
		flex-direction: row;
		gap: 0.5rem;
	}
	.item-grid {
		display: grid;
		grid-template-columns: 1fr auto;
		grid-auto-columns: auto;
		column-gap: 1rem;
		row-gap: 0.5rem;
		align-items: center;
		width: 100%;
	}

	.list-item {
		padding: 0.5rem 1rem;
		border-radius: 0.5rem;
		display: grid;
		align-items: center;
		grid-template-columns: subgrid;
		grid-column: 1 / -1;

		&:hover {
			background-color: hsl(from var(--background) h s calc(l * 0.9));
		}
	}
</style>
