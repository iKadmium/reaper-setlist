import { GetStateCommand, SetStateCommand } from './commands';
import type { ReaperApiClient } from './reaper-api';
import { SectionKeys, StateKeys, type StateKey } from './reaper-state';

export class ReaperScriptSettingsClient {
	constructor(private readonly apiClient: ReaperApiClient) {}

	private async getStateValue(key: StateKey): Promise<string | undefined> {
		const command = new GetStateCommand(SectionKeys.ReaperSetlist, key);
		const result = await this.apiClient.executeCommand(command);
		return result;
	}

	private async setStateValue(key: StateKey, value: string): Promise<void> {
		const command = new SetStateCommand(SectionKeys.ReaperSetlist, key, value, true);
		await this.apiClient.executeCommand(command);
	}

	async getProjectRoot(): Promise<string | undefined> {
		return await this.getStateValue(StateKeys.ProjectRoot);
	}

	async getScriptActionId(): Promise<string | undefined> {
		return await this.getStateValue(StateKeys.ScriptActionId);
	}

	async setProjectRoot(root: string): Promise<void> {
		await this.setStateValue(StateKeys.ProjectRoot, root);
	}

	async setScriptActionId(id: string): Promise<void> {
		await this.setStateValue(StateKeys.ScriptActionId, id);
	}
}
