import type { Setlist } from '../models/setlist';
import type { Song } from '../models/song';
import type { KeyValueStore } from './key-value-store';
import type { ReaperApiClient } from './reaper-backend/reaper-api';
import { ReaperBackend } from './reaper-backend/reaper-backend';
import type { ReaperRpcClient } from './reaper-backend/reaper-rpc-client.svelte';
import type { ReaperScriptSettingsClient } from './reaper-backend/reaper-script-settings';

// Re-export for backward compatibility
export type { CommandResults, ReaperCommand } from './reaper-backend/commands';

export type SongsStore = KeyValueStore<string, Song>;

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
