import type { Setlist } from '../models/setlist';
import type { Song } from '../models/song';
import type { KeyValueStore } from './key-value-store';
import { ReaperBackend } from './reaper-backend/reaper-backend';

export type ReaperCommand = string & { __brand: 'ReaperCommand' };

export interface ReaperApiClient {
	sendCommand: (command: ReaperCommand) => Promise<string>;
	sendCommands: (commands: ReaperCommand[]) => Promise<string[]>;

	goToStart: () => Promise<void>;
	goToEnd: () => Promise<void>;
	newTab: () => Promise<void>;
	closeAllTabs: () => Promise<void>;
}

export interface ReaperRpcClient {
	listProjects: () => Promise<string[]>;
	openProject: (projectPath: string) => Promise<void>;
	testActionId: (testNonce: string) => Promise<string>;
	getProjectLength(): Promise<number>;
}

export interface ReaperScriptSettingsClient {
	setProjectRoot: (root: string) => Promise<void>;
	getProjectRoot: () => Promise<string | undefined>;

	getScriptActionId: () => Promise<string | undefined>;
	setScriptActionId: (id: string) => Promise<void>;
}

export interface SongsStore extends KeyValueStore<string, Song> { }

export interface SetlistsStore extends KeyValueStore<string, Setlist> {
	deleteSongFromSets(id: string): unknown;
}

export interface Api {
	reaper: ReaperApiClient;
	songs: SongsStore;
	sets: SetlistsStore;
	script: ReaperRpcClient;
	scriptSettings: ReaperScriptSettingsClient;
}

export function getApi(fetch?: typeof globalThis.fetch): Api {
	return new ReaperBackend(fetch);
}
