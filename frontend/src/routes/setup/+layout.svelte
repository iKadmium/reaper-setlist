<script lang="ts">
	import Tabs from '$lib/components/Tabs/Tabs.svelte';
	import type { LayoutData } from './$types';
	import { goto } from '$app/navigation';
	import { page } from '$app/state';

	let { children: layoutChildren, data }: { children: any; data: LayoutData } = $props();

	const tabs = $derived([
		{ id: 'setup', label: 'Basic Setup', href: '/setup' },
		{
			id: 'installation',
			label: 'Installation' + (!data.canAccessInstallation ? ' *' : ''),
			href: data.canAccessInstallation ? '/setup/installation' : undefined,
			disabled: !data.canAccessInstallation
		}
	]);

	const activeTabId = $derived(data.activeTab);

	// Handle tab changes for non-href tabs
	function handleTabChange(tabId: string) {
		if (tabId === 'setup') {
			goto('/setup');
		} else if (tabId === 'installation' && data.canAccessInstallation) {
			goto('/setup/installation');
		} else if (tabId === 'test') {
			goto('/setup/test');
		}
	}
</script>

<meta:head>
	<title>Setup - Reaper Setlist</title>
</meta:head>

<h1>Setup</h1>

<Tabs {tabs} {activeTabId} onTabChange={handleTabChange}>
	{#snippet children(currentTab)}
		{#if !data.canAccessInstallation && activeTabId === 'installation'}
			<div class="info-message">
				<p><strong>Installation tab is disabled.</strong> Please complete the Basic Setup first by entering your Reaper URL and backing tracks folder path.</p>
			</div>
		{/if}
		<div class="tab-content">
			{@render layoutChildren()}
		</div>
	{/snippet}
</Tabs>

<style>
	.tab-content {
		width: 100%;
	}

	.info-message {
		padding: 1rem;
		background-color: hsl(from var(--yellow) h s calc(l * 0.1));
		border: 1px solid var(--yellow);
		border-radius: 0.5rem;
		margin-bottom: 1.5rem;
	}

	.info-message p {
		margin: 0;
		color: var(--foreground);
	}
</style>
