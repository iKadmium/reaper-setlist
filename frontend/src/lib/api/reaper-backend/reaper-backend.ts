import type { Song } from '$lib/models/song';
import type { Api, SetlistsStore, SongsStore } from '../api';
import { ReaperApiClient } from './reaper-api';
import { ReaperKVS } from './reaper-kvs';
import { ReaperRpcClient } from './reaper-rpc-client.svelte';
import { ReaperScriptSettingsClient } from './reaper-script-settings';
import { ReaperSetlistStoreImpl } from './reaper-setlist-store';
import { SectionKeys } from './reaper-state';

const REAPER_URL_ROOT = '/_';

export class ReaperBackend implements Api {
	public readonly reaper: ReaperApiClient;
	public readonly script: ReaperRpcClient;
	public readonly scriptSettings: ReaperScriptSettingsClient;
	public readonly songs: SongsStore;
	public readonly sets: SetlistsStore;

	constructor(
		fetch: typeof globalThis.fetch = globalThis.fetch,
		private readonly urlRoot: string = REAPER_URL_ROOT
	) {
		const apiClient = new ReaperApiClient(this.urlRoot, fetch);
		this.reaper = apiClient;
		this.script = new ReaperRpcClient(apiClient);
		this.scriptSettings = new ReaperScriptSettingsClient(apiClient);
		this.songs = new ReaperKVS<Song>(apiClient, this.script, SectionKeys.Songs);
		this.sets = new ReaperSetlistStoreImpl(apiClient, this.script, SectionKeys.Sets);
	}
}
