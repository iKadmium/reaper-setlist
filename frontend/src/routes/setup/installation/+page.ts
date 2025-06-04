import type { PageLoad } from './$types';
import type { ReaperSettings } from '$lib/models/reaper-settings';

export const load: PageLoad = async ({ fetch }) => {
    try {
        const response = await fetch('/api/settings');

        if (!response.ok) {
            throw new Error(`Failed to fetch settings: ${response.status}`);
        }

        const settings: ReaperSettings = await response.json();

        // Check if basic setup is complete
        if (!settings.folderPath || !settings.reaperUrl) {
            throw new Error('Setup incomplete. Please complete the basic setup first.');
        }

        return {
            settings
        };
    } catch (error) {
        return {
            error: error instanceof Error ? error.message : 'An unknown error occurred.',
            settings: {
                folderPath: '',
                reaperUrl: '',
                reaperUsername: '',
                reaperPassword: ''
            } as ReaperSettings
        };
    }
};
