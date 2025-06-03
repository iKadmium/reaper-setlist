import type { PageLoad } from './$types';
import type { Song } from '$lib/models/song';

export const load: PageLoad = async ({ fetch, params }) => {
    try {
        const id = params.id;
        const response = await fetch(`/api/songs/${id}`);

        if (!response.ok) {
            throw new Error(`Failed to fetch song: ${response.status}`);
        }

        const song: Song = await response.json();

        return {
            song
        };
    } catch (error) {
        return {
            song: undefined,
            error: error instanceof Error ? error.message : 'An unknown error occurred.'
        };
    }
};
