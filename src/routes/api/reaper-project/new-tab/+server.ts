import { newTab } from '$lib/server/reaper';

export async function POST() {
	try {
		await newTab();
		return Response.json({ success: true });
	} catch (error) {
		return Response.json({ success: false, error: (error as Error).message }, { status: 400 });
	}
}
