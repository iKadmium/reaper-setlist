import type { PageServerLoad } from './$types';
import { db } from '$lib/server/db';
import { songs } from '$lib/server/db/schema';

export const load: PageServerLoad = async () => {
	const allSongs = await db.select().from(songs).orderBy(songs.name);

	return {
		songs: allSongs
	};
};
