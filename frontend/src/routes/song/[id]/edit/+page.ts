import type { PageLoad } from './$types';
import type { Song } from '$lib/models/song';
import type { Database } from '$lib/models/database';
import type { ProjectListResponse } from '$lib/api/projects';

export const load: PageLoad = async ({ fetch, params }) => {
    try {
        const id = params.id;
        const [songsResponse, projectsResponse] = await Promise.all([
            fetch('/api/songs'),
            fetch('/api/projects/list')
        ]);

        if (!songsResponse.ok) {
            throw new Error(`Failed to fetch songs: ${songsResponse.status}`);
        }
        if (!projectsResponse.ok) {
            throw new Error(`Failed to fetch projects: ${projectsResponse.status}`);
        }

        const songs: Database<Song> = await songsResponse.json();
        const projects: ProjectListResponse = await projectsResponse.json();

        return {
            song: songs[id],
            songs: songs,
            projects: projects.projects
        };
    } catch (error) {
        throw new Error(`Error loading song data: ${error instanceof Error ? error.message : 'An unknown error occurred.'}`);
    }
};
