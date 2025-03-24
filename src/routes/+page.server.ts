import { db } from '$lib/server/db';
import { setlist_songs, setlists } from '$lib/server/db/schema';
import { getAllSetlistDenormalized } from '$lib/server/db/util';
import { desc } from 'drizzle-orm';

export async function load() {
	const sets = await db.select().from(setlists).orderBy(desc(setlists.date));
	const setSongs = await db.select().from(setlist_songs);

	const setsDenormalized = getAllSetlistDenormalized(sets, setSongs);

	return {
		sets: setsDenormalized
	};
}
