<script lang="ts">
	import { notifications } from '../../stores/notifications.svelte';
	import Notification from '../Notification/Notification.svelte';

	function handleDismiss(id: string) {
		notifications.remove(id);
	}
</script>

{#if notifications.items.length > 0}
	<div class="notification-container">
		{#each notifications.items as notification (notification.id)}
			<Notification {notification} onDismiss={handleDismiss} />
		{/each}
	</div>
{/if}

<style>
	.notification-container {
		position: fixed;
		top: 1rem;
		right: 1rem;
		z-index: 1000;
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		max-height: 80vh;
		overflow-y: auto;
		pointer-events: none;
	}

	.notification-container :global(.notification) {
		pointer-events: auto;
	}

	/* Responsive adjustments */
	@media (max-width: 640px) {
		.notification-container {
			top: 0.5rem;
			right: 0.5rem;
			left: 0.5rem;
			max-width: none;
		}

		.notification-container :global(.notification) {
			min-width: auto;
			max-width: none;
		}
	}
</style>
