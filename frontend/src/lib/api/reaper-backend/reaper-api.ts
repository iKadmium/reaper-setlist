import type { ReaperMarker } from '$lib/models/reaper-marker';
import type { ReaperApiClient, ReaperCommand } from '../api';

const GO_TO_START = '40042' as ReaperCommand;
const GET_TRANSPORT = 'TRANSPORT' as ReaperCommand;

const NEW_TAB = '40859' as ReaperCommand;
const CLOSE_ALL_TABS = '40860' as ReaperCommand;
const NEXT_TAB = '40861' as ReaperCommand;
const PREVIOUS_TAB = '40862' as ReaperCommand;

const PLAY = '1007' as ReaperCommand;
const PAUSE = '1008' as ReaperCommand;
const STOP = '1016' as ReaperCommand;
const RECORD = '1013' as ReaperCommand;

const GET_MARKERS = 'MARKER' as ReaperCommand;

export const PLAYSTATE_STOPPED = 0;
export const PLAYSTATE_PLAYING = 1;
export const PLAYSTATE_PAUSED = 2;
export const PLAYSTATE_RECORDING = 5;
export const PLAYSTATE_RECORD_PAUSED = 6;
export type PlayState =
	| typeof PLAYSTATE_STOPPED
	| typeof PLAYSTATE_PLAYING
	| typeof PLAYSTATE_PAUSED
	| typeof PLAYSTATE_RECORDING
	| typeof PLAYSTATE_RECORD_PAUSED;

export interface Transport {
	playState: PlayState;
	positionSeconds: number; // in seconds
	repeatOn: boolean; // true if repeat is on
	positionString: string; // formatted position string (e.g. "1.1.00")
	positionStringBeats: string; // formatted position in beats (e.g. "1.1.00")
}

export class ReaperApiClientImpl implements ReaperApiClient {
	private readonly urlRoot: string;
	private readonly fetch: typeof globalThis.fetch;

	constructor(urlRoot: string, fetch: typeof globalThis.fetch = globalThis.fetch) {
		this.urlRoot = urlRoot;
		this.fetch = fetch;
	}

	async getTransport(): Promise<Transport> {
		const result = await this.sendCommand(GET_TRANSPORT);
		const parts = result[0].split('\t');
		if (parts.length !== 6) {
			throw new Error(`Unexpected transport format: ${result}`);
		}

		const transport: Transport = {
			playState: parseInt(parts[1], 10) as PlayState,
			positionSeconds: parseFloat(parts[2]),
			repeatOn: parts[3] === '1',
			positionString: parts[4],
			positionStringBeats: parts[5]
		};

		return transport;
	}

	async goToStart(): Promise<void> {
		await this.sendCommand(GO_TO_START);
	}

	async play(): Promise<void> {
		await this.sendCommand(PLAY);
	}

	async pause(): Promise<void> {
		await this.sendCommand(PAUSE);
	}

	async stop(): Promise<void> {
		await this.sendCommand(STOP);
	}

	async record(): Promise<void> {
		await this.sendCommand(RECORD);
	}

	async newTab(): Promise<void> {
		await this.sendCommand(NEW_TAB);
	}

	async closeAllTabs(): Promise<void> {
		await this.sendCommand(CLOSE_ALL_TABS);
	}

	public async nextTab(): Promise<void> {
		await this.sendCommand(NEXT_TAB);
	}

	public async previousTab(): Promise<void> {
		await this.sendCommand(PREVIOUS_TAB);
	}

	public async getMarkers(): Promise<ReaperMarker[]> {
		const result = await this.sendCommand(GET_MARKERS);
		const markers: ReaperMarker[] = [];
		for (const line of result) {
			if (line === 'MARKER_LIST' || line === 'MARKER_LIST_END') {
				continue; // Skip header and footer
			}
			const parts = line.split('\t');
			if (parts.length < 4) {
				continue; // Skip invalid lines
			}
			const marker: ReaperMarker = {
				id: parseInt(parts[2], 10),
				name: parts[1],
				position: parseFloat(parts[3])
			};
			markers.push(marker);
		}
		return markers;
	}

	public async goToMarker(markerId: number): Promise<void> {
		const command = `SET/POS_STR/m${markerId}` as ReaperCommand;
		await this.sendCommand(command);
	}

	public async sendCommand(command: ReaperCommand): Promise<string[]> {
		const result = await this.fetch(`${this.urlRoot}/${command}`, {
			method: 'GET'
		});
		if (!result.ok) {
			throw new Error(`Failed to send command ${command}: ${result.statusText}`);
		}
		const content = await result.text();
		const lines = content.split('\n').filter((line) => line.trim() !== '');
		return lines;
	}

	public async sendCommands(commands: ReaperCommand[]): Promise<string[]> {
		const result = await this.fetch(`${this.urlRoot}/${commands.join(';')}`, {
			method: 'GET'
		});
		if (!result.ok) {
			throw new Error(`Failed to send commands ${commands.join(',')}: ${result.statusText}`);
		}
		const text = await result.text();
		return text.split('\n').slice(0, -1);
	}
}
