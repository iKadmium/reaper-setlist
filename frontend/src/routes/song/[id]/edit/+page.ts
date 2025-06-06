import { getApi } from '$lib/api/api';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, params }) => {
    try {
        const api = getApi(fetch);
        const id = params.id;
        const [songs, projects] = await Promise.all([
            api.songs.list(),
            api.reaper.listProjects()
        ]);

        return {
            song: songs[id],
            songs: songs,
            projects: projects
        };
    } catch (error) {
        throw new Error(`Error loading song data: ${error instanceof Error ? error.message : 'An unknown error occurred.'}`);
    }
};
