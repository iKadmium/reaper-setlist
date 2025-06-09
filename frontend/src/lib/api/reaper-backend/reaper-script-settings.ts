import type { ReaperApiClient, ReaperScriptSettingsClient } from "../api";
import type { ReaperScriptCommandBuilder } from "./reaper-script-command-builder";
import { StateKeys, type StateKey } from "./reaper-state";

export class ReaperScriptSettingsImpl implements ReaperScriptSettingsClient {
    constructor(
        private readonly apiClient: ReaperApiClient,
        private readonly commandBuilder: ReaperScriptCommandBuilder
    ) { }

    private async getStateValue(key: StateKey): Promise<string> {
        const command = this.commandBuilder.getExtState(key);
        const result = await this.apiClient.sendCommand(command);
        const output = result.split('\t')[3];
        return output;
    }

    private async setStateValue(key: StateKey, value: string): Promise<void> {
        const command = this.commandBuilder.setExtState(key, value);
        await this.apiClient.sendCommand(command);
    }

    async getProjectRoot(): Promise<string> {
        return await this.getStateValue(StateKeys.ProjectRoot);
    }

    async getScriptActionId(): Promise<string> {
        return await this.getStateValue(StateKeys.ScriptActionId);
    }

    async setProjectRoot(root: string): Promise<void> {
        await this.setStateValue(StateKeys.ProjectRoot, root);
    }

    async setScriptActionId(id: string): Promise<void> {
        await this.setStateValue(StateKeys.ScriptActionId, id);
    }
}