import { browser } from '$app/environment';
import { goto } from '$app/navigation';
import { getApi } from '$lib/api/api';
import type { LayoutLoad } from './$types';

export const ssr = false;

export const load: LayoutLoad = async ({ fetch, url }) => {
    try {
        const api = getApi(fetch);
        const scriptActionId = await api.settings.getScriptActionId();
        const folderPath = await api.settings.getFolderPath();

        const setupComplete: boolean = !!folderPath && !!scriptActionId;

        // If setup is not complete, navigate to setup page
        if (!setupComplete && browser && url.pathname !== '/setup') {
            goto('/setup');
            return { setupComplete };
        }

        return { setupComplete };
    } catch (error) {
        console.error('Error during setup check:', error);
        return { setupComplete: false };
    }
};