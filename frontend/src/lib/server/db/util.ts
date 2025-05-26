import { eq } from 'drizzle-orm';
import { db } from '.';
import {
	setlist_songs,
	setlists,
	type Setlist,
	type SetlistDenormalized,
	type SetlistSong,
	type Song
} from './schema';

export async function getSetlistDenormalized(id: number): Promise<SetlistDenormalized> {
	const setlist = await db.select().from(setlists).where(eq(setlists.id, id));

	const current_setlist_songs = await db
		.select()
		.from(setlist_songs)
		.where(eq(setlist_songs.setlistId, id));

	return {
		id: setlist[0].id,
		venue: setlist[0].venue,
		date: setlist[0].date.getTime(),
		songs: current_setlist_songs.map((song) => song.songId)
	};
}

export function getAllSetlistDenormalized(sets: Setlist[], setlistSongs: SetlistSong[]) {
	return sets.map((setlist) => {
		const current_setlist_songs = setlistSongs.filter(
			(setlistSong) => setlistSong.setlistId === setlist.id
		);
		return {
			id: setlist.id,
			venue: setlist.venue,
			date: setlist.date.getTime(),
			songs: current_setlist_songs.map((song) => song.songId)
		};
	});
}
