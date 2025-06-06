import { browser } from '$app/environment';
import { goto } from '$app/navigation';
import { getApi } from '$lib/api/api';
import type { LayoutLoad } from './$types';

export const load: LayoutLoad = async ({ fetch, url }) => {
    try {
        const api = getApi(fetch);
        const scriptActionId = await api.settings.getScriptActionId();
        const folderPath = await api.settings.getFolderPath();

        const setupComplete: boolean = !!folderPath && !!scriptActionId;

        // If setup is not complete, navigate to setup page
        if (!setupComplete && browser && url.pathname !== '/setup') {

            return { setupComplete };
        }

        return { setupComplete };
    } catch (error) {
        // For errors, log and continue (let pages handle their own error states)
        if (browser && url.pathname !== '/setup') {
            goto('/setup');
        }
        console.warn('Setup check failed:', error);
        return { setupComplete: false };
    }
};