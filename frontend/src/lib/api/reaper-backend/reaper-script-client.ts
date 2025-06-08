import { Lazy } from '$lib/util';
import type { ReaperApiClient, ReaperCommand } from '../api';
import { ReaperScriptCommandBuilder } from './reaper-script-accessor';
import { StateKeys } from './reaper-state';
import type { ScriptOperations } from './script-operations';

type ScriptOperationName = keyof ScriptOperations;

export class ReaperScriptClientImpl implements ScriptOperations {
	private readonly accessor: ReaperScriptCommandBuilder;
	private readonly apiClient: ReaperApiClient;
	private readonly ScriptId: Lazy<string>;

	constructor(apiClient: ReaperApiClient, accessor: ReaperScriptCommandBuilder) {
		this.apiClient = apiClient;
		this.accessor = accessor;
		this.ScriptId = new Lazy(() => {
			return this.accessor.getExtState(StateKeys.ScriptActionId);
		});
	}

	async listProjects(inputs: {}): Promise<{ projects: string[] }> {
		const commands: ReaperCommand[] = [];
		commands.push(this.accessor.setOperation('listProjects'));
		commands.push(await this.getRunScriptCommand());
		commands.push(this.accessor.getExtState('projects'));
		const results = await this.apiClient.sendCommands(commands);

		return results;
	}

	async openProject(inputs: { projectPath: string }): Promise<void> {
		return this.apiClient.sendCommand(this.accessor.openProject(inputs));
	}

	async testActionId(inputs: { nonce: string }): Promise<{ output: string }> {
		return this.apiClient.sendCommand(this.accessor.testActionId(inputs));
	}

	async getRunScriptCommand(): Promise<ReaperCommand> {
		const scriptId = await this.ScriptId.get();
		if (!scriptId) {
			throw new Error('Script action ID is not set');
		}
		return scriptId as ReaperCommand;
	}
}
