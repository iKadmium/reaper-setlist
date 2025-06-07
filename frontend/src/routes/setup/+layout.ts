import { getApi } from '$lib/api/api';
import type { PageLoad } from './$types';

export const load: PageLoad = async ({ fetch, url }: { fetch: any; url: any }) => {
	try {
		const api = getApi(fetch);

		// Determine the active tab from URL
		let activeTab = 'setup';
		if (url.pathname.includes('/installation')) {
			activeTab = 'installation';
		} else if (url.pathname.includes('/test')) {
			activeTab = 'test';
		}

		// Check if installation tab should be accessible
		const folderPath = await api.script.getFolderPath();
		const canAccessInstallation = folderPath;

		return {
			folderPath,
			activeTab,
			canAccessInstallation
		};
	} catch (error) {
		return {
			folderPath: '',
			activeTab: 'setup',
			canAccessInstallation: false,
			error: error instanceof Error ? error.message : 'An unknown error occurred.'
		};
	}
};
