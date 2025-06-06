import { generateUUID } from '$lib/util';
import type { ReaperApiClient } from '../api';
import { OperationKeys, StateKeys, type ReaperStateAccessor } from './reaper-state';

const GO_TO_END = '40043';
const GO_TO_START = '40042';
const GET_TRANSPORT = 'TRANSPORT';
const NEW_TAB = '40859';
const CLOSE_ALL_TABS = '40860';

export class ReaperApiClientImpl implements ReaperApiClient {
	private readonly accessor: ReaperStateAccessor;
	private readonly urlRoot: string;
	private readonly fetch: typeof globalThis.fetch;

	constructor(
		accessor: ReaperStateAccessor,
		urlRoot: string,
		fetch: typeof globalThis.fetch = globalThis.fetch
	) {
		this.accessor = accessor;
		this.urlRoot = urlRoot;
		this.fetch = fetch;
	}

	async setProjectRoot(root: string): Promise<void> {
		this.accessor.setExtState(StateKeys.ProjectPath, root, false);
	}

	async listProjects(): Promise<string[]> {
		const actionId = await this.accessor.getExtState(StateKeys.ScriptActionId);
		await this.accessor.SetOperation(OperationKeys.ListProjects);
		await this.sendCommand(actionId);
		const result = await this.accessor.getExtState(StateKeys.ScriptOutput);

		const lines = result.split('\n').filter((line) => line.trim() !== '');
		const projects = lines[0].split(',');
		return projects;
	}

	async loadByFilename(name: string): Promise<void> {
		const actionId = await this.accessor.getExtState(StateKeys.ScriptActionId);
		await this.accessor.setExtState(StateKeys.ProjectPath, name, false);
		await this.accessor.SetOperation(OperationKeys.OpenProject);
		await this.sendCommand(actionId);
		const result = await this.accessor.getExtState(StateKeys.ScriptOutput);

		if (result !== 'OK') {
			throw new Error(`Failed to load project: ${result}`);
		}
	}

	async testActionId(actionId: string): Promise<boolean> {
		const input = generateUUID();
		await this.accessor.setExtState(StateKeys.TestInput, input, false);
		await this.accessor.SetOperation(OperationKeys.TestActionId);
		await this.sendCommand(actionId);
		const result = await this.accessor.getExtState(StateKeys.ScriptOutput);
		const expectedOutput = `Test input received: ${input}`;

		return result === expectedOutput;
	}

	async getDuration(): Promise<number> {
		await this.goToEnd();
		const transport = await this.getTransport();
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
		return parts[1];
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

	async testConnection(): Promise<boolean> {
		try {
			const result = await this.getTransport();
			return result !== undefined && result.length > 0;
		} catch (error) {
			console.error('Connection test failed:', error);
			return false;
		}
	}

	private async sendCommand(command: string): Promise<string> {
		const result = await this.fetch(`${this.urlRoot}/${command}`, {
			method: 'GET'
		});
		if (!result.ok) {
			throw new Error(`Failed to send command ${command}: ${result.statusText}`);
		}
		return await result.text();
	}
}
