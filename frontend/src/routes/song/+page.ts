import type { PageLoad } from './$types';
import type { Database } from '$lib/models/database';
import type { Song } from '$lib/models/song';

export const load: PageLoad = async ({ fetch }) => {
    try {
        const response = await fetch('/api/songs');

        if (!response.ok) {
            throw new Error(`Failed to fetch songs: ${response.status}`);
        }

        const songs: Database<Song> = await response.json();

        return {
            songs
        };
    } catch (error) {
        return {
            songs: {} as Database<Song>,
            error: error instanceof Error ? error.message : 'An unknown error occurred.'
        };
    }
};
