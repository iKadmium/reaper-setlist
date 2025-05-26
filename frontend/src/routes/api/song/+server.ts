import { db } from '$lib/server/db';
import { songs, type SongInsert } from '$lib/server/db/schema';

export async function POST({ request }: { request: Request }) {
	try {
		const json = (await request.json()) as SongInsert;
		await db.insert(songs).values(json);
		return Response.json({ success: true });
	} catch (error) {
		return Response.json({ success: false, error: (error as Error).message }, { status: 400 });
	}
}
