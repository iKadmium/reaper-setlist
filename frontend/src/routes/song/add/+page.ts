import { getApi } from '$lib/api/api';
import type { Database } from '$lib/models/database';
import type { Song } from '$lib/models/song';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch }) => {
	try {
		const api = getApi(fetch);

		const [projects, songs] = await Promise.all([api.script.listProjects(), api.songs.list()]);

		return {
			songs,
			projects
		};
	} catch (error) {
		return {
			projects: [],
			songs: {} as Database<Song>,
			error: error instanceof Error ? error.message : 'An unknown error occurred.'
		};
	}
};
