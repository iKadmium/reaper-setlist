import type { PageLoad } from './$types';
import type { ReaperSettings } from '$lib/models/reaper-settings';

export const load: PageLoad = async ({ fetch, url }: { fetch: any; url: any }) => {
	try {
		const response = await fetch('/api/settings');

		if (!response.ok) {
			throw new Error(`Failed to fetch settings: ${response.status}`);
		}

		const settings: ReaperSettings = await response.json();

		// Determine the active tab from URL
		let activeTab = 'setup';
		if (url.pathname.includes('/installation')) {
			activeTab = 'installation';
		} else if (url.pathname.includes('/test')) {
			activeTab = 'test';
		}

		// Check if installation tab should be accessible
		const canAccessInstallation = settings.folderPath && settings.reaperUrl;

		return {
			settings,
			activeTab,
			canAccessInstallation
		};
	} catch (error) {
		return {
			settings: {
				folderPath: '',
				reaperUrl: '',
				reaperUsername: '',
				reaperPassword: ''
			} as ReaperSettings,
			activeTab: 'setup',
			canAccessInstallation: false,
			error: error instanceof Error ? error.message : 'An unknown error occurred.'
		};
	}
};
