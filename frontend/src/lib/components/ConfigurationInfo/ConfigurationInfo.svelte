<!-- ConfigurationInfo.svelte - A utility component that shows current configuration state -->
<script lang="ts">
	import { configuration } from '$lib';

	// Access the cached configuration values
	const config = $derived(configuration.data);
	const isSetupComplete = $derived(configuration.isSetupComplete);
</script>

{#if config}
	<div class="config-info">
		<h3>Configuration Status</h3>
		<dl>
			<dt>Setup Complete:</dt>
			<dd class:success={isSetupComplete} class:error={!isSetupComplete}>
				{isSetupComplete ? 'Yes' : 'No'}
			</dd>

			<dt>Script Action ID:</dt>
			<dd class:success={config.scriptActionId} class:warning={!config.scriptActionId}>
				{config.scriptActionId || 'Not set'}
			</dd>

			<dt>Folder Path:</dt>
			<dd class:success={config.folderPath} class:warning={!config.folderPath}>
				{config.folderPath || 'Not set'}
			</dd>
		</dl>
	</div>
{:else}
	<div class="config-info loading">
		<p>Loading configuration...</p>
	</div>
{/if}

<style>
	.config-info {
		padding: 1rem;
		border: 1px solid var(--current-line);
		border-radius: 0.5rem;
		background-color: hsl(from var(--background) h s calc(l * 1.05));
		margin: 1rem 0;
	}

	.config-info h3 {
		margin: 0 0 1rem 0;
		color: var(--foreground);
		font-size: 1.1rem;
	}

	.config-info dl {
		margin: 0;
		display: grid;
		grid-template-columns: auto 1fr;
		gap: 0.5rem;
		align-items: center;
	}

	.config-info dt {
		font-weight: 500;
		color: var(--foreground);
	}

	.config-info dd {
		margin: 0;
		font-family: monospace;
		padding: 0.25rem 0.5rem;
		border-radius: 0.25rem;
		background-color: var(--current-line);
	}

	.config-info dd.success {
		color: var(--green);
		background-color: hsl(from var(--green) h s l / 0.1);
	}

	.config-info dd.warning {
		color: var(--yellow);
		background-color: hsl(from var(--yellow) h s l / 0.1);
	}

	.config-info dd.error {
		color: var(--red);
		background-color: hsl(from var(--red) h s l / 0.1);
	}

	.config-info.loading {
		text-align: center;
		color: var(--comment);
	}
</style>
