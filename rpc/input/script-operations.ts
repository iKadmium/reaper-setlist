interface ReaperTab {
	index: number;
	name: string;
	length: number;
}

type Chunkable<T> = T & { __chunkable: true };

export interface ScriptOperations {
	listProjects: () => { projects: string[] };
	openProject: (projectPath: string) => void;
	testActionId: (testNonce: string) => { testOutput: string };
	getProjectLength: () => { projectLength: number };
	getOpenTabs: () => { tabs: ReaperTab[] };
	writeChunkedData: <T>(section: string, key: string, chunks: Chunkable<T>) => void;
	deleteState: (section: string, key: string) => void;
}
