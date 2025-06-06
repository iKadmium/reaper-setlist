import type { ReaperSettingsStore } from "../api";
import { ReaperStateAccessor } from "./reaper-state";

export class ReaperSettingsStoreImpl implements ReaperSettingsStore {
    private readonly accessor: ReaperStateAccessor;
    private readonly urlRoot: string;

    constructor(urlRoot: string, accessor: ReaperStateAccessor) {
        this.accessor = accessor;
        this.urlRoot = urlRoot;
    }

    async getFolderPath(): Promise<string | undefined> {
        return this.accessor.getExtState(`folderPath`);
    }
    async setFolderPath(path: string): Promise<void> {
        await this.accessor.setExtState(`folderPath`, path);
    }
    async getScriptActionId(): Promise<string | undefined> {
        return this.accessor.getExtState(`scriptActionId`);
    }
    async setScriptActionId(id: string): Promise<void> {
        await this.accessor.setExtState(`scriptActionId`, id);
    }
}