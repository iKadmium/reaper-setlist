import { getConfig } from '$lib/server/config';
import { getScript } from '$lib/server/reaper';

export async function GET() {
	const config = await getConfig();
	if (!config || !config.folderPath) {
		return new Response('Backing Track Folder Path not set', { status: 400 });
	}

	const script = getScript(config.folderPath);
	return new Response(script, { status: 200 });
}
