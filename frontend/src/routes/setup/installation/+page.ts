import { getApi } from '$lib/api/api';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch }) => {
	try {
		const api = getApi(fetch);
		const [scriptActionId, folderPath] = await Promise.all([
			api.script.getScriptActionId(),
			api.script.getFolderPath()
		]);

		// Check if basic setup is complete
		if (!folderPath) {
			throw new Error('Setup incomplete. Please complete the basic setup first.');
		}

		return {
			scriptActionId
		};
	} catch (error) {
		return {
			error: error instanceof Error ? error.message : 'An unknown error occurred.',
			scriptActionId: undefined
		};
	}
};
