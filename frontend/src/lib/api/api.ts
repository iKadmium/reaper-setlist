import type { ReaperSettings } from "../models/reaper-settings";
import type { Setlist } from "../models/setlist";
import type { Song } from "../models/song";
import type { KeyValueStore } from "./key-value-store";
import { ReaperBackend } from "./reaper-backend/reaper-backend";

export interface ReaperApiClient {
    setProjectRoot: (root: string) => Promise<void>,
    listProjects: () => Promise<string[]>,
    loadByFilename: (name: string) => Promise<void>,

    testConnection: (settings: ReaperSettings) => Promise<boolean>,
    testActionId(actionId: string): Promise<boolean>;

    getDuration: () => Promise<number>,
    goToStart: () => Promise<void>,
    goToEnd: () => Promise<void>,
    newTab: () => Promise<void>,
    closeAllTabs: () => Promise<void>,
}

export interface SongsStore extends KeyValueStore<string, Song> { }

export interface SetlistsStore extends KeyValueStore<string, Setlist> { }

export interface ReaperSettingsStore {
    getFolderPath: () => Promise<string | undefined>,
    setFolderPath: (path: string) => Promise<void>,

    getScriptActionId: () => Promise<string | undefined>,
    setScriptActionId: (id: string) => Promise<void>,
}

export interface Api {
    reaper: ReaperApiClient,
    songs: SongsStore,
    sets: SetlistsStore,
    settings: ReaperSettingsStore
}

export function getApi(fetch?: typeof globalThis.fetch): Api {
    return new ReaperBackend(fetch);
}