import { generateUUID } from '$lib/util';
import type { ReaperApiClient } from '../api';
import { ReaperMiscStateAccessor } from './reaper-misc-state-accessor';
import { OperationKeys, SectionKeys, StateKeys } from './reaper-state';

export class ReaperScriptClientImpl {
	private readonly apiClient: ReaperApiClient;
	private readonly accessor: ReaperMiscStateAccessor;

	constructor(apiClient: ReaperApiClient) {
		this.apiClient = apiClient;
		this.accessor = new ReaperMiscStateAccessor(this.apiClient, SectionKeys.ReaperSetlist);
	}

	async setProjectRoot(root: string): Promise<void> {
		this.accessor.setExtState(StateKeys.ProjectPath, root, false);
	}

	async listProjects(): Promise<string[]> {
		const actionId = await this.accessor.getExtState(StateKeys.ScriptActionId);
		await this.accessor.SetOperation(OperationKeys.ListProjects);
		await this.apiClient.sendCommand(actionId);
		const result = await this.accessor.getExtState(StateKeys.ScriptOutput);

		const lines = result.split('\n').filter((line) => line.trim() !== '');
		const projects = lines[0].split(',');
		return projects;
	}

	async loadByFilename(name: string): Promise<void> {
		const actionId = await this.accessor.getExtState(StateKeys.ScriptActionId);
		await this.accessor.setExtState(StateKeys.ProjectPath, name, false);
		await this.accessor.SetOperation(OperationKeys.OpenProject);
		await this.apiClient.sendCommand(actionId);
	}

	async testActionId(actionId: string): Promise<boolean> {
		const input = generateUUID();
		await this.accessor.setExtState(StateKeys.TestInput, input, false);
		await this.accessor.SetOperation(OperationKeys.TestActionId);
		await this.apiClient.sendCommand(actionId);
		const result = await this.accessor.getExtState(StateKeys.ScriptOutput);
		const expectedOutput = `Test input received: ${input}`;

		return result === expectedOutput;
	}

	async getFolderPath(): Promise<string | undefined> {
		return this.accessor.getExtState(StateKeys.ProjectRoot);
	}
	async setFolderPath(path: string): Promise<void> {
		await this.accessor.setExtState(StateKeys.ProjectRoot, path);
	}
	async getScriptActionId(): Promise<string | undefined> {
		return this.accessor.getExtState(StateKeys.ScriptActionId);
	}
	async setScriptActionId(id: string): Promise<void> {
		await this.accessor.setExtState(StateKeys.ScriptActionId, id);
	}
}
