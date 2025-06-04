<script lang="ts" module>
	export interface Tab {
		id: string;
		label: string;
		href?: string;
		disabled?: boolean;
	}

	export interface TabsProps {
		tabs: Tab[];
		activeTabId: string;
		onTabChange?: (tabId: string) => void;
		children: import('svelte').Snippet<[string]>;
	}
</script>

<script lang="ts">
	let { tabs, activeTabId, onTabChange, children }: TabsProps = $props();

	function handleTabClick(tab: Tab) {
		if (tab.disabled) return;
		if (tab.href) {
			// Let the browser handle navigation
			return;
		}
		onTabChange?.(tab.id);
	}
</script>

<div class="tabs-container">
	<div class="tab-list" role="tablist">
		{#each tabs as tab}
			{#if tab.href && !tab.disabled}
				<a
					class="tab-button"
					class:active={activeTabId === tab.id}
					class:disabled={tab.disabled}
					href={tab.href}
					role="tab"
					aria-selected={activeTabId === tab.id}
					aria-disabled={tab.disabled}
				>
					{tab.label}
				</a>
			{:else}
				<button
					class="tab-button"
					class:active={activeTabId === tab.id}
					class:disabled={tab.disabled}
					onclick={() => handleTabClick(tab)}
					role="tab"
					aria-selected={activeTabId === tab.id}
					aria-disabled={tab.disabled}
					disabled={tab.disabled}
				>
					{tab.label}
				</button>
			{/if}
		{/each}
	</div>

	<div class="tab-content" role="tabpanel">
		{@render children(activeTabId)}
	</div>
</div>

<style>
	.tabs-container {
		width: 100%;
	}

	.tab-list {
		display: flex;
		border-bottom: 2px solid var(--current-line);
		margin-bottom: 1.5rem;
	}

	.tab-button {
		background: none;
		border: none;
		padding: 0.75rem 1.5rem;
		cursor: pointer;
		font-size: 1rem;
		font-weight: 500;
		color: var(--comment);
		text-decoration: none;
		border-bottom: 2px solid transparent;
		transition: all 0.2s ease;
		position: relative;
		top: 2px;
	}

	.tab-button:hover {
		color: var(--foreground);
		background-color: hsl(from var(--background) h s calc(l * 1.1));
	}

	.tab-button.active {
		color: var(--primary);
		border-bottom-color: var(--primary);
		background-color: hsl(from var(--background) h s calc(l * 1.1));
	}

	.tab-button.disabled {
		color: var(--comment);
		cursor: not-allowed;
		opacity: 0.5;
	}

	.tab-button.disabled:hover {
		color: var(--comment);
		background-color: transparent;
	}

	.tab-content {
		width: 100%;
	}

	/* Responsive design */
	@media (max-width: 768px) {
		.tab-button {
			padding: 0.5rem 1rem;
		}
	}
</style>
