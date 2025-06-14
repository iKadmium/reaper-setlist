import { generateUUID } from '$lib/util';
import type { ButtonColor } from '../components/Button/Button.svelte';

export interface Notification {
	id: string;
	message: string;
	type: ButtonColor;
	duration?: number; // milliseconds, undefined means manual dismiss
	timestamp: Date;
}

class NotificationStore {
	private notifications = $state<Notification[]>([]);

	get items() {
		return this.notifications;
	}

	add(message: string, type: ButtonColor = 'primary', duration?: number): string {
		const id = generateUUID();
		const notification: Notification = {
			id,
			message,
			type,
			duration,
			timestamp: new Date()
		};

		// Use array assignment instead of push to ensure reactivity
		this.notifications = [...this.notifications, notification];

		// Auto-remove after duration if specified
		if (duration !== undefined) {
			setTimeout(() => {
				this.remove(id);
			}, duration);
		}

		return id;
	}

	remove(id: string) {
		this.notifications = this.notifications.filter((n) => n.id !== id);
	}

	clear() {
		this.notifications = [];
	}

	// Convenience methods
	success(message: string, duration = 5000) {
		return this.add(message, 'success', duration);
	}

	error(message: string, duration?: number) {
		return this.add(message, 'delete', duration);
	}

	warning(message: string, duration = 7000) {
		return this.add(message, 'edit', duration);
	}

	info(message: string, duration = 5000) {
		return this.add(message, 'primary', duration);
	}
}

export const notifications = new NotificationStore();
