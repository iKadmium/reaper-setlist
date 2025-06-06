import type { Setlist } from '$lib/models/setlist';
import type { Song } from '$lib/models/song';
import type { Api, ReaperApiClient, ReaperSettingsStore, SetlistsStore, SongsStore } from '../api';
import { ReaperApiClientImpl } from './reaper-api';
import { ReaperKVS } from './reaper-kvs';
import { ReaperSetlistStoreImpl } from './reaper-setlist-store';
import { ReaperSettingsStoreImpl } from './reaper-settings-store';
import { KVStores, ReaperStateAccessor, SectionKeys } from './reaper-state';

const REAPER_URL_ROOT = '/_';

export class ReaperBackend implements Api {
	public readonly reaper: ReaperApiClient;
	public readonly settings: ReaperSettingsStore;
	public readonly songs: SongsStore;
	public readonly sets: SetlistsStore;

	constructor(
		fetch: typeof globalThis.fetch = globalThis.fetch,
		private readonly urlRoot: string = REAPER_URL_ROOT
	) {
		const stateAccessor = new ReaperStateAccessor(SectionKeys.ReaperSetlist, this.urlRoot, fetch);
		this.settings = new ReaperSettingsStoreImpl(stateAccessor);
		this.reaper = new ReaperApiClientImpl(stateAccessor, this.urlRoot, fetch);
		this.songs = new ReaperKVS<Song>(KVStores.Songs, stateAccessor);
		this.sets = new ReaperSetlistStoreImpl(KVStores.Sets, stateAccessor);
	}
}
