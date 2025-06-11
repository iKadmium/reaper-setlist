import type { ReaperMarker } from '$lib/models/reaper-marker';
import type { ReaperTab } from '$lib/models/reaper-tab';
import type { ReaperTransport } from '$lib/models/reaper-transport';
import type { Setlist } from '../models/setlist';
import type { Song } from '../models/song';
import type { KeyValueStore } from './key-value-store';
import type { ReaperCommand, CommandResults } from './reaper-backend/commands';
import { ReaperBackend } from './reaper-backend/reaper-backend';

// Re-export for backward compatibility
export type { ReaperCommand, CommandResults } from './reaper-backend/commands';

export interface ReaperApiClient {
	// New type-safe command methods
	executeCommand: <TReturn, TInput, TResponse extends string | undefined>(command: ReaperCommand<TReturn, TInput, TResponse>) => Promise<TReturn>;
	executeCommands: <T extends readonly ReaperCommand<any, any, any>[]>(commands: T) => Promise<CommandResults<T>>;

	// High-level API methods
	goToStart: () => Promise<ReaperTransport>;
	goToMarker: (markerId: number) => Promise<ReaperTransport>;

	newTab: () => Promise<void>;
	closeAllTabs: () => Promise<void>;
	nextTab: () => Promise<{ markers: ReaperMarker[], transport: ReaperTransport }>;
	previousTab: () => Promise<{ markers: ReaperMarker[], transport: ReaperTransport }>;

	play: () => Promise<ReaperTransport>;
	pause: () => Promise<ReaperTransport>;
	stop: () => Promise<ReaperTransport>;
	record: () => Promise<ReaperTransport>;
	getTransport: () => Promise<ReaperTransport>;

	getMarkers: () => Promise<ReaperMarker[]>;
}

export interface ReaperRpcClient {
	listProjects: () => Promise<string[]>;
	openProject: (projectPath: string) => Promise<void>;
	testActionId: (testNonce: string) => Promise<string>;
	getProjectLength(): Promise<number>;
	getOpenTabs: () => Promise<ReaperTab[]>;
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
