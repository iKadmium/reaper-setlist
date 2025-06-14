<script lang="ts" module>
	import type { Snippet } from 'svelte';

	export interface ItemGridProps<T> {
		items: T[];
		nameDisplay?: Snippet<[T]>;
		getName?: (item: T) => string;
		actions: Snippet<[T]>;
	}
</script>

<script lang="ts">
	// eslint-disable-next-line no-undef
	type T = $$Generic;

	let { items, nameDisplay, getName, actions }: ItemGridProps<T> = $props();
</script>

<div class="item-grid">
	{#each items as item (item)}
		<div class="list-item">
			<div class="name">
				{#if nameDisplay}
					{@render nameDisplay(item)}
				{:else if getName}
					{getName(item)}
				{/if}
			</div>
			<div class="actions">
				{@render actions(item)}
			</div>
		</div>
	{/each}
</div>

<style>
	.name {
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		min-width: 0; /* Allow text to wrap */
	}

	.actions {
		display: flex;
		flex-direction: row;
		gap: 0.5rem;
		flex-shrink: 0; /* Prevent actions from shrinking */
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
