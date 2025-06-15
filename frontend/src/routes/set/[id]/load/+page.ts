import { getApi } from '$lib/api/api';
import type { Database } from '$lib/models/database';
import type { ReaperTab } from '$lib/models/reaper-tab';
import type { Song } from '$lib/models/song';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, params }) => {
	try {
		const id = params.id;
		const api = getApi(fetch);

		const [set, songs, tabs] = await Promise.all([
			api.sets.get(id),
			api.songs.list(),
			api.script.getOpenTabs()
		]);

		return {
			set,
			songs,
			tabs
		};
	} catch (error) {
		return {
			set: undefined,
			songs: {} as Database<Song>,
			tabs: { activeIndex: -1, tabs: [] },
			error: error instanceof Error ? error.message : 'An unknown error occurred.'
		};
	}
};
