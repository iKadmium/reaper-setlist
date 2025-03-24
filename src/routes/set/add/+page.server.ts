import { db } from '$lib/server/db';
import { songs } from '$lib/server/db/schema';

export async function load() {
	const allSongs = await db.select().from(songs);
	return {
		songs: allSongs
	};
}
