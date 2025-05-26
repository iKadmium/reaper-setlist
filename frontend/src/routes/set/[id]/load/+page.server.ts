import { db } from '$lib/server/db';
import { songs } from '$lib/server/db/schema';
import { getSetlistDenormalized } from '$lib/server/db/util';
import type { RouteParams } from './$types';

export async function load({ params }: { params: RouteParams }) {
	const setlistId = parseInt(params.id, 10);
	const setDenormalised = await getSetlistDenormalized(setlistId);

	const allSongs = await db.select().from(songs).orderBy(songs.name);

	return {
		set: setDenormalised,
		songs: allSongs
	};
}
