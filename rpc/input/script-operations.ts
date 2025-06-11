interface ReaperTab {
	index: number;
	name: string;
	length: number;
}

export interface ScriptOperations {
	listProjects: () => { projects: string[] };
	openProject: (projectPath: string) => void;
	testActionId: (testNonce: string) => { testOutput: string };
	getProjectLength: () => { projectLength: number };
	getOpenTabs: () => { tabs: ReaperTab[] };
}
