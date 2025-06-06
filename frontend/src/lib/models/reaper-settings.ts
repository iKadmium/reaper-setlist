export interface ReaperSettings {
	folderPath: string;
	reaperUrl: string;
	reaperUsername?: string;
	reaperPassword?: string;
	scriptActionId?: string;
}

export interface TestConnectionRequest {
	reaper_url: string;
	reaper_username?: string;
	reaper_password?: string;
}

export interface TestConnectionResponse {
	success: boolean;
	message: string;
}
