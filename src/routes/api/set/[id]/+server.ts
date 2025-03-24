import { db } from '$lib/server/db';
import { setlists, setlist_songs, type SetlistDenormalized } from '$lib/server/db/schema';
import { eq } from 'drizzle-orm';

export async function PUT({ request, params }) {
	try {
		const body = (await request.json()) as SetlistDenormalized;
		const setlistId = parseInt(params.id, 10);
		if (body.id !== setlistId) {
			return new Response('ID in URL does not match ID in body', { status: 400 });
		}
		// Use a transaction to ensure atomicity
		await db.transaction(async (trx) => {
			// Update the setlist
			await trx
				.update(setlists)
				.set({
					venue: body.venue,
					date: new Date(body.date)
				})
				.where(eq(setlists.id, setlistId));

			// Delete the existing songs
			await trx.delete(setlist_songs).where(eq(setlist_songs.setlistId, setlistId));

			// Insert the songs into the setlist_songs table
			if (body.songs && Array.isArray(body.songs)) {
				const setlistSongs = body.songs.map((songId: number, index: number) => ({
					setlistId: setlistId,
					songId,
					order: index + 1
				}));

				await trx.insert(setlist_songs).values(setlistSongs);
			}
		});

		return Response.json({ success: true }, { status: 200 });
	} catch (error) {
		console.error(error);
		return new Response('Internal Server Error', { status: 500 });
	}
}

export async function DELETE({ params }) {
	try {
		const setlistId = parseInt(params.id, 10);
		await db.transaction(async (trx) => {
			// Delete the songs
			await trx.delete(setlist_songs).where(eq(setlist_songs.setlistId, setlistId));

			// Delete the setlist
			await trx.delete(setlists).where(eq(setlists.id, setlistId));
		});

		return Response.json({ success: true }, { status: 200 });
	} catch (error) {
		console.error(error);
		return new Response('Internal Server Error', { status: 500 });
	}
}
