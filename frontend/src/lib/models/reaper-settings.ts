export interface ReaperSettings {
	folderPath: string;
	reaperUrl: string;
	reaperUsername?: string;
	reaperPassword?: string;
	setRootScriptActionId?: string;
	loadProjectScriptActionId?: string;
	listProjectsScriptActionId?: string;
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
