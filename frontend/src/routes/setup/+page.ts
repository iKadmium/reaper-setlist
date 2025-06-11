import { configuration } from '$lib';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch }) => {
	try {
		// Ensure configuration is initialized before accessing values
		await configuration.ensureInitialized(fetch);

		return {
			folderPath: configuration.folderPath || '',
			scriptActionId: configuration.scriptActionId || ''
		};
	} catch (error) {
		return {
			folderPath: '',
			scriptActionId: '',
			error: error instanceof Error ? error.message : 'An unknown error occurred.'
		};
	}
};
