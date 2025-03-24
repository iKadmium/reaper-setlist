import { getTransport, goToEnd, goToStart } from '$lib/server/reaper';

export interface GetDurationResponseBody {
	duration?: number;
	error?: string;
}

export async function POST() {
	try {
		await goToEnd();
		const transport = await getTransport();
		await goToStart();

		const responseBody: GetDurationResponseBody = {
			duration: transport
		};
		return Response.json(responseBody);
	} catch (error) {
		console.error(error);

		const responseBody: GetDurationResponseBody = {
			error: (error as Error).message
		};
		return Response.json(responseBody, { status: 500 });
	}
}
