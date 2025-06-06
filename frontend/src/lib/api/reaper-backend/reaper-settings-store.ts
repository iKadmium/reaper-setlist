import type { ReaperSettingsStore } from '../api';
import { ReaperStateAccessor, StateKeys } from './reaper-state';

export class ReaperSettingsStoreImpl implements ReaperSettingsStore {
	private readonly accessor: ReaperStateAccessor;

	constructor(accessor: ReaperStateAccessor) {
		this.accessor = accessor;
	}

	async getFolderPath(): Promise<string | undefined> {
		return this.accessor.getExtState(StateKeys.ProjectPath);
	}
	async setFolderPath(path: string): Promise<void> {
		await this.accessor.setExtState(StateKeys.ProjectPath, path);
	}
	async getScriptActionId(): Promise<string | undefined> {
		return this.accessor.getExtState(StateKeys.ScriptActionId);
	}
	async setScriptActionId(id: string): Promise<void> {
		await this.accessor.setExtState(StateKeys.ScriptActionId, id);
	}
}
