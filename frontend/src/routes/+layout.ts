import { browser } from '$app/environment';
import { goto } from '$app/navigation';
import { base } from '$app/paths';
import { configuration } from '$lib';
import type { LayoutLoad } from './$types';

// export const ssr = false;

export const load: LayoutLoad = async ({ fetch, url }) => {
	try {
		// Ensure configuration is initialized
		await configuration.ensureInitialized(fetch);
		const setupComplete = configuration.isSetupComplete;

		// If setup is not complete, navigate to setup page (but only if not already there)
		if (!setupComplete && browser && url.pathname !== '/setup' && !url.hash?.includes('/setup')) {
			goto(`#/setup`);
			return { setupComplete };
		}

		return { setupComplete };
	} catch (error) {
		console.error('Error during setup check:', error);
		return { setupComplete: false };
	}
};
