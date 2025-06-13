import { getApi } from '$lib/api/api';
import type { Database } from '$lib/models/database';
import type { Song } from '$lib/models/song';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, params }) => {
	try {
		const id = params.id;
		const api = getApi(fetch);

		const [set, songs] = await Promise.all([api.sets.get(id), api.songs.list()]);

		return {
			set,
			songs
		};
	} catch (error) {
		return {
			set: undefined,
			songs: {} as Database<Song>,
			error: error instanceof Error ? error.message : 'An unknown error occurred.'
		};
	}
};
