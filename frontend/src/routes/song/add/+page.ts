import type { ProjectListResponse } from '$lib/api/projects';
import type { Database } from '$lib/models/database';
import type { Song } from '$lib/models/song';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch }) => {
    try {
        const [listResponse, songsResponse] = await Promise.all([
            fetch('/api/projects/list'),
            fetch('/api/songs')
        ]);

        if (!listResponse.ok) {
            throw new Error(`Failed to fetch projects: ${listResponse.status}`);
        }

        if (!songsResponse.ok) {
            throw new Error(`Failed to fetch songs: ${songsResponse.status}`);
        }

        const projects: ProjectListResponse = await listResponse.json() as ProjectListResponse;
        const songs: Database<Song> = await songsResponse.json() as Database<Song>;

        return {
            songs,
            projects: projects.projects
        };
    } catch (error) {
        return {
            projects: [],
            songs: {} as Database<Song>,
            error: error instanceof Error ? error.message : 'An unknown error occurred.'
        };
    }
};
