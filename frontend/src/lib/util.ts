import { RunScriptCommand } from "./api/reaper-backend/commands";
import type { ReaperMarker } from "./models/reaper-marker";
import type { PlayState, ReaperTransport } from "./models/reaper-transport";
import { configuration } from "./stores/configuration.svelte";

export function formatDuration(seconds: number): string {
	const minutes = Math.floor(seconds / 60);
	const remainingSeconds = Math.floor(seconds % 60);
	return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
}

export function generateUUID(): string {
	if (typeof crypto !== 'undefined' && crypto.randomUUID) {
		return crypto.randomUUID();
	}

	// Fallback: generate a pseudo-UUID using Math.random()
	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
		const r = (Math.random() * 16) | 0;
		const v = c === 'x' ? r : (r & 0x3) | 0x8;
		return v.toString(16);
	});
}

export function parseTransportString(transportString: string): ReaperTransport {
	const parts = transportString.split('\t');
	if (parts.length !== 6) {
		throw new Error(`Unexpected transport format: ${transportString}`);
	}

	const transport: ReaperTransport = {
		playState: parseInt(parts[1], 10) as PlayState,
		positionSeconds: parseFloat(parts[2]),
		repeatOn: parts[3] === '1',
		positionString: parts[4],
		positionStringBeats: parts[5]
	};
	return transport;
}

export class Lazy<T> {
	private value: T | undefined;
	private readonly factory: () => Promise<T>;

	constructor(factory: () => Promise<T>) {
		this.factory = factory;
	}

	async get(): Promise<T> {
		if (this.value === undefined) {
			this.value = await this.factory();
		}
		return Promise.resolve(this.value);
	}

	reset(): void {
		this.value = undefined;
	}
}
