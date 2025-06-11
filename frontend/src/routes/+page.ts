import type { PageLoad } from './$types';
import type { Database } from '$lib/models/database';
import type { Setlist } from '$lib/models/setlist';
import type { Song } from '$lib/models/song';
import { getApi } from '$lib/api/api';

export const load: PageLoad = async ({ fetch }) => {
    try {
        const api = getApi(fetch);
        const [sets, songs] = await Promise.all([
            api.sets.list(),
            api.songs.list()
        ]);

        return {
            sets,
            songs
        };
    } catch (error) {
        console.error('Error loading sets and songs:', error);
        return {
            sets: {} as Database<Setlist>,
            songs: {} as Database<Song>,
            error: error instanceof Error ? error.message : 'An unknown error occurred.'
        };
    }
};
