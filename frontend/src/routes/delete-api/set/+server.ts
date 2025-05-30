import { db } from '$lib/server/db';
import { setlists, setlist_songs, type Setlist } from '$lib/server/db/schema';

export async function POST({ request }) {
	try {
		const body = (await request.json()) as Setlist;

		// Use a transaction to ensure atomicity
		const setlist = await db.transaction(async (trx) => {
			// Insert the setlist
			const [newSetlist] = await trx
				.insert(setlists)
				.values({
					venue: body.venue,
					date: new Date(body.date)
				})
				.returning();

			if (!newSetlist) {
				throw new Error('Failed to create setlist');
			}

			// Insert the songs into the setlist_songs table
			if (body.songs && Array.isArray(body.songs)) {
				const setlistSongs = body.songs.map((songId: number, index: number) => ({
					setlistId: newSetlist.id,
					songId,
					order: index + 1
				}));

				await trx.insert(setlist_songs).values(setlistSongs);
			}

			return newSetlist;
		});

		if (!setlist) {
			return new Response('Failed to create setlist', { status: 500 });
		}

		return new Response(JSON.stringify(setlist), { status: 201 });
	} catch (error) {
		console.error(error);
		return new Response('Internal Server Error', { status: 500 });
	}
}
