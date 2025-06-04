<script lang="ts">
	interface FormProps {
		children: import('svelte').Snippet;
		onsubmit?: (event: SubmitEvent) => void;
		class?: string;
	}

	let { children, onsubmit, class: className = '' }: FormProps = $props();
</script>

<form class="form-card {className}" {onsubmit}>
	{@render children()}
</form>

<style>
	.form-card {
		background: var(--background);
		padding: 2rem;
		border-radius: 0.75rem;
		border: 1px solid var(--current-line);
		margin-top: 1.5rem;
		box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3);
		width: 100%;
		box-sizing: border-box;
		display: flex;
		flex-direction: column;
		gap: 1.5rem;
	}

	/* Responsive design */
	@media (max-width: 768px) {
		.form-card {
			margin: 1rem;
			padding: 1.5rem;
		}
	}
</style>
