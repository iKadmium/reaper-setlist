import type { Setlist } from '$lib/models/setlist';
import type { Song } from '$lib/models/song';
import type { Api, ReaperApiClient, ReaperScriptClient, SetlistsStore, SongsStore } from '../api';
import { ReaperApiClientImpl } from './reaper-api';
import { ReaperKVS } from './reaper-kvs';
import { ReaperScriptCommandBuilder } from './reaper-script-accessor';
import { ReaperScriptClientImpl } from './reaper-script-client';
import { ReaperSetlistStoreImpl } from './reaper-setlist-store';
import { SectionKeys } from './reaper-state';
import { ReaperStoreAccessor } from './reaper-store-accessor';

const REAPER_URL_ROOT = '/_';

export class ReaperBackend implements Api {
	public readonly reaper: ReaperApiClient;
	public readonly script: ReaperScriptClient;
	public readonly songs: SongsStore;
	public readonly sets: SetlistsStore;

	constructor(
		fetch: typeof globalThis.fetch = globalThis.fetch,
		private readonly urlRoot: string = REAPER_URL_ROOT
	) {
		const apiClient = new ReaperApiClientImpl(this.urlRoot, fetch);
		this.script = new ReaperScriptClientImpl(
			apiClient,
			new ReaperScriptCommandBuilder(apiClient, SectionKeys.Script)
		);
		this.reaper = apiClient;
		this.songs = new ReaperKVS<Song>(new ReaperStoreAccessor<Song>(SectionKeys.Songs, apiClient));
		this.sets = new ReaperSetlistStoreImpl(
			new ReaperStoreAccessor<Setlist>(SectionKeys.Sets, apiClient)
		);
	}
}
