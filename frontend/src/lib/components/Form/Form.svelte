<script lang="ts">
	interface FormProps {
		children: import('svelte').Snippet;
		onsubmit?: (event: SubmitEvent) => void;
		class?: string;
	}

	let { children, onsubmit, class: className = '' }: FormProps = $props();

	function handleSubmit(event: SubmitEvent) {
		event.preventDefault();
		onsubmit?.(event);
	}
</script>

<form class="form-card {className}" onsubmit={handleSubmit}>
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
			margin: 0;
			padding: 0;
			border: 0;
			box-shadow: none;
		}
	}
</style>
