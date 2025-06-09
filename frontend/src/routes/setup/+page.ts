import { getApi } from '$lib/api/api';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch }) => {
	try {
		const api = getApi(fetch);

		const folderPath = await api.scriptSettings.getProjectRoot();
		const scriptActionId = await api.scriptSettings.getScriptActionId();

		return {
			folderPath,
			scriptActionId
		};
	} catch (error) {
		return {
			folderPath: '',
			scriptActionId: '',
			error: error instanceof Error ? error.message : 'An unknown error occurred.'
		};
	}
};
