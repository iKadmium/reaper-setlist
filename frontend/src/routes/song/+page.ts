import type { PageLoad } from './$types';
import type { Database } from '$lib/models/database';
import type { Song } from '$lib/models/song';
import { getApi } from '$lib/api/api';

export const load: PageLoad = async ({ fetch }) => {
	try {
		const api = getApi(fetch);
		const [songs, projects] = await Promise.all([api.songs.list(), api.script.listProjects()]);

		return {
			songs,
			projects
		};
	} catch (error) {
		return {
			songs: {} as Database<Song>,
			error: error instanceof Error ? error.message : 'An unknown error occurred.'
		};
	}
};
