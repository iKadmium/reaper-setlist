import type { PageLoad } from './$types';
import type { Database } from '$lib/models/database';
import type { Setlist } from '$lib/models/setlist';
import type { Song } from '$lib/models/song';

export const load: PageLoad = async ({ fetch }) => {
    try {
        const [setResponse, songResponse] = await Promise.all([
            fetch('/api/sets'),
            fetch('/api/songs')
        ]);

        if (!setResponse.ok) {
            const errorData = await setResponse.json();
            throw new Error(errorData.error || `Failed to fetch sets: ${setResponse.status}`);
        }
        const sets: Database<Setlist> = await setResponse.json();

        if (!songResponse.ok) {
            const errorData = await songResponse.json();
            throw new Error(errorData.error || `Failed to fetch songs: ${songResponse.status}`);
        }
        const songs: Database<Song> = await songResponse.json();

        return {
            sets,
            songs
        };
    } catch (error) {
        return {
            sets: {} as Database<Setlist>,
            songs: {} as Database<Song>,
            error: error instanceof Error ? error.message : 'An unknown error occurred.'
        };
    }
};
