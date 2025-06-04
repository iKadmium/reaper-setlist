<script lang="ts">
	export interface NextStep {
		label: string;
		href: string;
	}

	interface NextStepsProps {
		title?: string;
		steps: NextStep[];
		variant?: 'default' | 'success' | 'info';
	}

	let { title = 'Next steps:', steps, variant = 'default' }: NextStepsProps = $props();

	const variantClasses = {
		default: 'next-steps--default',
		success: 'next-steps--success',
		info: 'next-steps--info'
	};
</script>

<div class="next-steps {variantClasses[variant]}">
	<p><strong>{title}</strong></p>
	<ul>
		{#each steps as step}
			<li><a href={step.href}>{step.label}</a></li>
		{/each}
	</ul>
</div>

<style>
	.next-steps {
		margin-top: 2rem;
		padding: 1rem;
		background-color: var(--background-secondary, rgba(255, 255, 255, 0.05));
		border-radius: 0.5rem;
		border-left: 4px solid var(--purple);
	}

	.next-steps--success {
		border-left-color: var(--green);
	}

	.next-steps--info {
		border-left-color: var(--cyan);
	}

	.next-steps ul {
		margin: 0.5rem 0 0 0;
	}

	.next-steps li {
		list-style-type: none;
	}

	.next-steps a {
		color: var(--purple);
		text-decoration: none;
		font-weight: 500;
	}

	.next-steps a:hover {
		text-decoration: underline;
	}

	.next-steps--success a {
		color: var(--green);
	}

	.next-steps--info a {
		color: var(--cyan);
	}

	.next-steps p {
		margin-top: 0;
	}
</style>
