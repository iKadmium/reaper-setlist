import { db } from '$lib/server/db';
import { songs } from '$lib/server/db/schema';
import type { RouteParams } from './$types';
import { eq } from 'drizzle-orm';

export async function load({ params }: { params: RouteParams }) {
	const song = await db
		.select()
		.from(songs)
		.where(eq(songs.id, parseInt(params.id, 10)));
	return {
		song: song[0]
	};
}
