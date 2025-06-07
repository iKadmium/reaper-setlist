import type { ReaperApiClient } from '../api';

const GO_TO_END = '40043';
const GO_TO_START = '40042';
const GET_TRANSPORT = 'TRANSPORT';
const NEW_TAB = '40859';
const CLOSE_ALL_TABS = '40860';

export class ReaperApiClientImpl implements ReaperApiClient {
	private readonly urlRoot: string;
	private readonly fetch: typeof globalThis.fetch;

	constructor(urlRoot: string, fetch: typeof globalThis.fetch = globalThis.fetch) {
		this.urlRoot = urlRoot;
		this.fetch = fetch;
	}

	async getDuration(): Promise<number> {
		await this.goToEnd();
		const transport = await this.getTransport();
		console.log();
		const seconds = parseInt(transport);
		if (isNaN(seconds)) {
			throw new Error(`Invalid transport value: ${transport}`);
		}
		return seconds;
	}

	private async getTransport(): Promise<string> {
		const result = await this.sendCommand(GET_TRANSPORT);
		const parts = result.split('\t');
		if (parts.length < 2) {
			throw new Error(`Unexpected transport format: ${result}`);
		}
		return parts[2];
	}

	async goToStart(): Promise<void> {
		await this.sendCommand(GO_TO_START);
	}

	async goToEnd(): Promise<void> {
		await this.sendCommand(GO_TO_END);
	}

	async newTab(): Promise<void> {
		await this.sendCommand(NEW_TAB);
	}

	async closeAllTabs(): Promise<void> {
		await this.sendCommand(CLOSE_ALL_TABS);
	}

	public async sendCommand(command: string): Promise<string> {
		const result = await this.fetch(`${this.urlRoot}/${command}`, {
			method: 'GET'
		});
		if (!result.ok) {
			throw new Error(`Failed to send command ${command}: ${result.statusText}`);
		}
		return await result.text();
	}

	public async sendCommands(commands: string[]): Promise<string[]> {
		const result = await this.fetch(`${this.urlRoot}/${commands.join(';')}`, {
			method: 'GET'
		});
		if (!result.ok) {
			throw new Error(`Failed to send commands ${commands.join(',')}: ${result.statusText}`);
		}
		const text = await result.text();
		return text.split('\n').filter((line) => line.trim() !== '');
	}
}
