import type { PageLoad } from './$types';
import type { ReaperSettings } from '$lib/models/reaper-settings';

export const load: PageLoad = async ({ fetch }) => {
    try {
        const response = await fetch('/api/settings');

        if (!response.ok) {
            throw new Error(`Failed to fetch settings: ${response.status}`);
        }

        const settings: ReaperSettings = await response.json();

        return {
            settings
        };
    } catch (error) {
        return {
            settings: {
                folderPath: '',
                reaperUrl: '',
                reaperUsername: '',
                reaperPassword: ''
            } as ReaperSettings,
            error: error instanceof Error ? error.message : 'An unknown error occurred.'
        };
    }
};
