import { getConfig, setConfig } from '$lib/server/config';
import { fail } from '@sveltejs/kit';
import type { Actions } from './$types';

export async function load() {
	const config = await getConfig();
	return {
		reaperUrl: config.reaperUrl,
		folderPath: config.folderPath
	};
}

export const actions = {
	default: async (event) => {
		const data = await event.request.formData();
		const reaperUrl = data.get('reaper-url');
		const folderPath = data.get('backing-tracks-folder');
		if (!reaperUrl || !folderPath) {
			return fail(400, { message: 'Missing reaperUrl or folderPath' });
		}
		if (typeof reaperUrl !== 'string' || typeof folderPath !== 'string') {
			return fail(400, { message: 'Invalid reaperUrl or folderPath' });
		}
		if (!reaperUrl.startsWith('http')) {
			return fail(400, { message: 'Invalid reaperUrl' });
		}

		await setConfig({ reaperUrl, folderPath });
		return { success: true };
	}
} satisfies Actions;
