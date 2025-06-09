import { getApi } from '$lib/api/api';

export interface Configuration {
    scriptActionId?: string;
    folderPath?: string;
    setupComplete: boolean;
}

class ConfigurationStore {
    private configuration = $state<Configuration>({
        scriptActionId: undefined,
        folderPath: undefined,
        setupComplete: false
    });

    private initialized = false;
    private initializing = false;
    private initPromise: Promise<void> | null = null;

    get data() {
        return this.configuration;
    }

    get isSetupComplete() {
        return this.configuration.setupComplete;
    }

    get scriptActionId() {
        return this.configuration.scriptActionId;
    }

    get folderPath() {
        return this.configuration.folderPath;
    }

    async initialize(fetch?: typeof globalThis.fetch) {
        // If already initialized, return immediately
        if (this.initialized) return;

        // If already initializing, wait for the existing promise
        if (this.initializing && this.initPromise) {
            return this.initPromise;
        }

        // Mark as initializing and create promise
        this.initializing = true;
        this.initPromise = this._doInitialize(fetch);

        try {
            await this.initPromise;
        } finally {
            this.initializing = false;
            this.initPromise = null;
        }
    }

    private async _doInitialize(fetch?: typeof globalThis.fetch) {
        try {
            const api = getApi(fetch);
            const [scriptActionId, folderPath] = await Promise.all([
                api.scriptSettings.getScriptActionId(),
                api.scriptSettings.getProjectRoot()
            ]);

            this.configuration.scriptActionId = scriptActionId;
            this.configuration.folderPath = folderPath;
            this.configuration.setupComplete = !!(folderPath && scriptActionId);
            this.initialized = true;
        } catch (error) {
            console.error('Error initializing configuration:', error);
            this.configuration.setupComplete = false;
        }
    }

    // Synchronous method to ensure initialization starts immediately
    // Returns a promise that resolves when initialization is complete
    ensureInitialized(fetch?: typeof globalThis.fetch): Promise<void> {
        if (this.initialized) {
            return Promise.resolve();
        }
        return this.initialize(fetch);
    }

    async updateScriptActionId(id: string, fetch?: typeof globalThis.fetch) {
        try {
            const api = getApi(fetch);
            await api.scriptSettings.setScriptActionId(id);
            this.configuration.scriptActionId = id;
            this.updateSetupComplete();
        } catch (error) {
            console.error('Error updating script action ID:', error);
            throw error;
        }
    }

    async updateFolderPath(path: string, fetch?: typeof globalThis.fetch) {
        try {
            const api = getApi(fetch);
            await api.scriptSettings.setProjectRoot(path);
            this.configuration.folderPath = path;
            this.updateSetupComplete();
        } catch (error) {
            console.error('Error updating folder path:', error);
            throw error;
        }
    }

    private updateSetupComplete() {
        this.configuration.setupComplete = !!(
            this.configuration.folderPath &&
            this.configuration.scriptActionId
        );
    }

    reset() {
        this.configuration.scriptActionId = undefined;
        this.configuration.folderPath = undefined;
        this.configuration.setupComplete = false;
        this.initialized = false;
        this.initializing = false;
        this.initPromise = null;
    }
}

export const configuration = new ConfigurationStore();
