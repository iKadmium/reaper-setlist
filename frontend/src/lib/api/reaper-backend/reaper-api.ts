import type { ReaperApiClient, ReaperSettingsStore } from "../api";
import type { ReaperStateAccessor } from "./reaper-state";

const GO_TO_END = "40043";
const GO_TO_START = "40042";
const GET_TRANSPORT = "TRANSPORT";
const NEW_TAB = "40859";
const CLOSE_ALL_TABS = "40860";

export class ReaperApiClientImpl implements ReaperApiClient {
    private readonly accessor: ReaperStateAccessor;
    private readonly urlRoot: string;
    private readonly fetch: typeof globalThis.fetch;

    constructor(accessor: ReaperStateAccessor, urlRoot: string, fetch: typeof globalThis.fetch = globalThis.fetch) {
        this.accessor = accessor;
        this.urlRoot = urlRoot;
        this.fetch = fetch;
    }

    async setProjectRoot(root: string): Promise<void> {
        this.accessor.setExtState('project_root', root, false);
    }

    async listProjects(): Promise<string[]> {
        throw new Error("Method not implemented.");
    }

    async loadByFilename(name: string): Promise<void> {
        throw new Error("Method not implemented.");
    }

    async testActionId(actionId: string): Promise<boolean> {
        throw new Error("Method not implemented.");
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
            console.error("Connection test failed:", error);
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