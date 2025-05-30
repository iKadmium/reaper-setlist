import { db } from '$lib/server/db';
import { songs, type SongInsert } from '$lib/server/db/schema';
import { eq } from 'drizzle-orm';
import type { RouteParams } from './$types';

export async function PUT({ request, params }: { request: Request; params: RouteParams }) {
	try {
		const json = (await request.json()) as SongInsert;
		const songId = parseInt(params.id, 10);
		if (json.id !== songId) {
			throw new Error('Song ID does not match');
		}
		await db.update(songs).set(json).where(eq(songs.id, songId));
		return Response.json({ success: true });
	} catch (error) {
		console.error(error);
		return Response.json({ success: false, error: (error as Error).message }, { status: 400 });
	}
}

export async function DELETE({ params }: { request: Request; params: RouteParams }) {
	try {
		const songId = parseInt(params.id, 10);
		await db.delete(songs).where(eq(songs.id, songId));
		return Response.json({ success: true });
	} catch (error) {
		console.error(error);
		return Response.json({ success: false, error: (error as Error).message }, { status: 400 });
	}
}
