import { Lazy } from '$lib/util';
import type { ReaperApiClient, ReaperCommand } from '../api';
import {
	ReaperScriptCommandBuilder,
	type ScriptOperationInput
} from './reaper-script-command-builder';
import { StateKeys } from './reaper-state';
import type { ScriptOperations } from '../../../../../rpc/input/script-operations';

type ScriptOperationName = keyof ScriptOperations;

export class ReaperScriptClientImpl implements ScriptOperations {
	private readonly accessor: ReaperScriptCommandBuilder;
	private readonly apiClient: ReaperApiClient;
	private readonly ScriptId: Lazy<string>;

	constructor(apiClient: ReaperApiClient, accessor: ReaperScriptCommandBuilder) {
		this.apiClient = apiClient;
		this.accessor = accessor;
		this.ScriptId = new Lazy(() => {
			const command = this.accessor.getExtState(StateKeys.ScriptActionId);
			return this.apiClient.sendCommand(command).then((result) => {
				if (typeof result !== 'string') {
					throw new Error('Script action ID is not set');
				}
				return result;
			});
		});
	}

	private async runOperation<T extends ScriptOperationName>(
		operation: T,
		inputs: Parameters<ScriptOperations[T]>[0]
	): Promise<ReturnType<ScriptOperations[T]>> {
		const commands: ReaperCommand[] = [];
		for (const [key, value] of Object.entries(inputs)) {
			const typedKey = key as ScriptOperationInput;
			commands.push(this.accessor.setExtState(typedKey, value));
		}
		commands.push(this.accessor.setOperation(operation));
		commands.push(await this.getRunScriptCommand());

		commands.push(this.accessor.setInputs(inputs));
		return this.apiClient.sendCommands(commands);
	}

	async listProjects(inputs: {}): Promise<{ projects: string[] }> {
		const commands: ReaperCommand[] = [];
		commands.push(this.accessor.setOperation('listProjects'));
		commands.push(await this.getRunScriptCommand());
		commands.push(this.accessor.getExtState('projects'));
		const results = await this.apiClient.sendCommands(commands);
		const ouputIndex = Object.keys(inputs).length + 2;

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
