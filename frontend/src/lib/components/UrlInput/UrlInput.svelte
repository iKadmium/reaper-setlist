<script lang="ts">
	import Button from '$lib/components/Button/Button.svelte';
	import TestIcon from 'virtual:icons/mdi/check-network';

	interface UrlInputProps {
		value: string;
		id: string;
		name: string;
		placeholder?: string;
		onTest: () => void;
		testLabel?: string;
	}

	let { value = $bindable(), id, name, placeholder = '', onTest, testLabel = 'Test Connection' }: UrlInputProps = $props();
</script>

<div class="url-input-container">
	<input bind:value type="text" {id} {name} {placeholder} />
	<Button elementType="button" color="primary" onclick={onTest}>
		<TestIcon />
		{testLabel}
	</Button>
</div>

<style>
	.url-input-container {
		display: flex;
		gap: 0.75rem;
		align-items: flex-end;
		width: 100%;
	}

	.url-input-container input {
		flex: 1;
		margin: 0;
	}

	/* Responsive design */
	@media (max-width: 768px) {
		.url-input-container {
			flex-direction: column;
			align-items: stretch;
			gap: 0.5rem;
		}
	}
</style>
