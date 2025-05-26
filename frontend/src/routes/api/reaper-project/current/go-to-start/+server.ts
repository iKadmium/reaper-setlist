import { goToStart } from '$lib/server/reaper';

export async function POST() {
	try {
		await goToStart();
		return Response.json({ status: 200, body: { message: 'Go to start' } });
	} catch (e) {
		console.error(e);
		return Response.json({ status: 500, body: { message: 'Error' } });
	}
}
