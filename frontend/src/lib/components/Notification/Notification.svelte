<script module lang="ts">
	import type { ButtonColor } from '../Button/Button.svelte';
	import type { Notification } from '../../stores/notifications.svelte';

	export interface Props {
		notification: Notification;
		onDismiss?: (id: string) => void;
	}
</script>

<script lang="ts">
	import { onMount } from 'svelte';
	import { fly, fade } from 'svelte/transition';
	import Button from '../Button/Button.svelte';
	import CloseIcon from 'virtual:icons/mdi/close';

	let { notification, onDismiss }: Props = $props();

	function getHsl(color: ButtonColor | undefined): string {
		switch (color) {
			default:
			case 'primary':
				return 'var(--primary)';
			case 'delete':
				return 'var(--red)';
			case 'edit':
				return 'var(--yellow)';
			case 'success':
				return 'var(--green)';
		}
	}

	function getBorderColor(color: ButtonColor | undefined): string {
		return getHsl(color);
	}

	function getBackgroundColor(color: ButtonColor | undefined): string {
		const baseColor = getHsl(color);
		return `hsl(from ${baseColor} h s calc(l * 0.1))`;
	}

	const borderColor = $derived(getBorderColor(notification.type));
	const backgroundColor = $derived(getBackgroundColor(notification.type));

	function handleDismiss() {
		onDismiss?.(notification.id);
	}
</script>

<div
	class="notification"
	style="border-color: {borderColor}; background-color: {backgroundColor};"
	in:fly={{ x: 300, duration: 300 }}
	out:fade={{ duration: 200 }}
>
	<div class="content">
		<p class="message">{notification.message}</p>
		<span class="timestamp">{notification.timestamp.toLocaleTimeString()}</span>
	</div>
	<Button elementType="button" color={notification.type} onclick={handleDismiss}>
		<CloseIcon />
	</Button>
</div>

<style>
	.notification {
		display: flex;
		align-items: flex-start;
		justify-content: space-between;
		gap: 1rem;
		padding: 1rem;
		border: 2px solid;
		border-radius: 0.5rem;
		min-width: 300px;
		max-width: 500px;
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
	}

	.content {
		flex: 1;
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.message {
		margin: 0;
		color: var(--foreground);
		font-weight: 500;
	}

	.timestamp {
		font-size: 0.75rem;
		color: var(--comment);
		opacity: 0.8;
	}
</style>
