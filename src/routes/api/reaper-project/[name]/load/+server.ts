import { loadProject } from '$lib/server/reaper';
import type { RouteParams } from './$types';

export async function POST({ params }: { params: RouteParams }) {
	try {
		await loadProject(params.name);
		return Response.json({ success: true });
	} catch (error) {
		console.error(error);
		return Response.json({ success: false, error: (error as Error).message }, { status: 400 });
	}
}
