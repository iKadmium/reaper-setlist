<script lang="ts">
	import type { Snippet } from 'svelte';
	import CheckIcon from 'virtual:icons/mdi/check-circle';
	import LoadingIcon from 'virtual:icons/line-md/loading-loop';
	import ErrorIcon from 'virtual:icons/mdi/alert-circle';

	export interface StepProps {
		title: string;
		description?: string;
		status: StepStatus;
		icon?: Snippet;
	}

	export type StepStatus = 'pending' | 'running' | 'completed' | 'error';

	let { title, description, status, icon }: StepProps = $props();

	function getStatusIcon() {
		switch (status) {
			case 'completed':
				return CheckIcon;
			case 'running':
				return LoadingIcon;
			case 'error':
				return ErrorIcon;
			default:
				return null;
		}
	}

	function getStatusClass() {
		switch (status) {
			case 'completed':
				return 'step--completed';
			case 'running':
				return 'step--running';
			case 'error':
				return 'step--error';
			default:
				return 'step--pending';
		}
	}

	const StatusIcon = $derived(getStatusIcon());
</script>

<div class="step {getStatusClass()}">
	<div class="step-indicator">
		{#if StatusIcon}
			<StatusIcon />
		{:else if icon}
			{@render icon()}
		{:else}
			<div class="step-number"></div>
		{/if}
	</div>

	<div class="step-content">
		<h3 class="step-title">{title}</h3>
		{#if description}
			<p class="step-description">{description}</p>
		{/if}
	</div>
</div>

<style>
	.step {
		display: flex;
		align-items: flex-start;
		gap: 1rem;
		padding: 1rem;
		border-radius: 0.5rem;
		border: 1px solid var(--current-line);
		background-color: var(--background);
		transition: all 0.2s ease;
	}

	.step-indicator {
		display: flex;
		align-items: center;
		justify-content: center;
		width: 2rem;
		height: 2rem;
		border-radius: 50%;
		font-size: 1.5rem;
		flex-shrink: 0;
		transition: all 0.2s ease;
	}

	.step-number {
		width: 0.75rem;
		height: 0.75rem;
		border-radius: 50%;
		background-color: var(--comment);
	}

	.step-content {
		flex: 1;
	}

	.step-title {
		margin: 0 0 0.25rem 0;
		font-size: 1rem;
		font-weight: 600;
		color: var(--foreground);
	}

	.step-description {
		margin: 0;
		font-size: 0.875rem;
		color: var(--comment);
		line-height: 1.4;
	}

	/* Status variants */
	.step--pending {
		opacity: 0.7;
	}

	.step--pending .step-indicator {
		background-color: var(--background);
		border: 2px solid var(--comment);
	}

	.step--running {
		border-color: var(--cyan);
		background-color: hsl(from var(--cyan) h s l / 0.05);
	}

	.step--running .step-indicator {
		color: var(--cyan);
		background-color: hsl(from var(--cyan) h s l / 0.1);
	}

	.step--completed {
		border-color: var(--green);
		background-color: hsl(from var(--green) h s l / 0.05);
	}

	.step--completed .step-indicator {
		color: var(--green);
		background-color: hsl(from var(--green) h s l / 0.1);
	}

	.step--error {
		border-color: var(--red);
		background-color: hsl(from var(--red) h s l / 0.05);
	}

	.step--error .step-indicator {
		color: var(--red);
		background-color: hsl(from var(--red) h s l / 0.1);
	}
</style>
