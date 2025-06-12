import type { ReaperMarker } from '$lib/models/reaper-marker';
import type { ReaperTab } from '$lib/models/reaper-tab';
import type { ReaperTransport } from '$lib/models/reaper-transport';
import type { Setlist } from '../models/setlist';
import type { Song } from '../models/song';
import type { KeyValueStore } from './key-value-store';
import type { ReaperCommand, CommandResults } from './reaper-backend/commands';
import type { ReaperApiClient } from './reaper-backend/reaper-api';
import { ReaperBackend } from './reaper-backend/reaper-backend';
import type { ReaperRpcClient } from './reaper-backend/reaper-rpc-client.svelte';

// Re-export for backward compatibility
export type { ReaperCommand, CommandResults } from './reaper-backend/commands';

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
