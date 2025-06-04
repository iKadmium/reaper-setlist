import type { ReaperSettings } from '$lib/models/reaper-settings';
import { goto } from '$app/navigation';
import { browser } from '$app/environment';
import type { LayoutLoad } from './$types';

export const load: LayoutLoad = async ({ fetch, url }) => {


    try {
        const response = await fetch('/api/settings');

        if (!response.ok) {
            throw new Error(`Failed to check setup status: ${response.status}`);
        }

        const setupData = await response.json() as ReaperSettings;

        const setupComplete = setupData.folderPath?.length > 0 && setupData.reaperUrl?.length > 0;

        // If setup is not complete, navigate to setup page
        if (!setupComplete && browser && url.pathname !== '/setup') {
            goto('/setup');
            return { setupComplete };
        }

        return { setupComplete };
    } catch (error) {
        // For errors, log and continue (let pages handle their own error states)
        console.warn('Setup check failed:', error);
        return { setupComplete: false };
    }
};