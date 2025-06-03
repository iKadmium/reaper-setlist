import type { PageLoad } from './$types';
import type { Database } from '$lib/models/database';
import type { Setlist } from '$lib/models/setlist';
import type { Song } from '$lib/models/song';

export const load: PageLoad = async ({ fetch, params }) => {
    try {
        const id = params.id;

        const [setResponse, songsResponse] = await Promise.all([
            fetch(`/api/sets/${id}`),
            fetch('/api/songs')
        ]);

        if (!setResponse.ok) {
            throw new Error(`Failed to fetch set: ${setResponse.status}`);
        }
        const set: Setlist = await setResponse.json();

        if (!songsResponse.ok) {
            throw new Error(`Failed to fetch songs: ${songsResponse.status}`);
        }
        const songs: Database<Song> = await songsResponse.json();

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
