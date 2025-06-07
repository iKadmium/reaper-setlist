<script lang="ts">
	export interface InstructionStep {
		label: string;
		href?: string;
	}

	interface InstructionBoxProps {
		title: string;
		steps: InstructionStep[];
		variant?: 'default' | 'success' | 'info' | 'help';
		listType?: 'ordered' | 'unordered';
	}

	let { title, steps, variant = 'default', listType = 'unordered' }: InstructionBoxProps = $props();

	const variantClasses = {
		default: 'instruction-box--default',
		success: 'instruction-box--success',
		info: 'instruction-box--info',
		help: 'instruction-box--help'
	};
</script>

<div class="instruction-box {variantClasses[variant]}">
	<h2>{title}</h2>
	{#if listType === 'ordered'}
		<ol>
			{#each steps as step}
				<li>
					{#if step.href}
						<a href={`#${step.href}`}>{step.label}</a>
					{:else}
						{step.label}
					{/if}
				</li>
			{/each}
		</ol>
	{:else}
		<ul>
			{#each steps as step}
				<li>
					{#if step.href}
						<a href={`#${step.href}`}>{step.label}</a>
					{:else}
						{step.label}
					{/if}
				</li>
			{/each}
		</ul>
	{/if}
</div>

<style>
	.instruction-box {
		padding: 1rem;
		background-color: var(--background-secondary, rgba(255, 255, 255, 0.05));
		border-radius: 0.5rem;
		border-left: 4px solid var(--purple);
		width: 100%;
		box-sizing: border-box;
		margin: 2rem 0;
	}

	.instruction-box--success {
		border-left-color: var(--green);
	}

	.instruction-box--info {
		border-left-color: var(--cyan);
	}

	.instruction-box--help {
		border-left-color: var(--purple);
	}

	.instruction-box h2 {
		margin-top: 0;
		margin-bottom: 0.5rem;
	}

	.instruction-box ul,
	.instruction-box ol {
		margin: 0.5rem 0 0 0;
		padding-left: 1.5rem;
	}

	.instruction-box li {
		margin-bottom: 0.25rem;
	}

	.instruction-box a {
		color: var(--purple);
		text-decoration: none;
		font-weight: 500;
	}

	.instruction-box a:hover {
		text-decoration: underline;
	}

	.instruction-box--success a {
		color: var(--green);
	}

	.instruction-box--info a {
		color: var(--cyan);
	}

	.instruction-box--help a {
		color: var(--purple);
	}
</style>
