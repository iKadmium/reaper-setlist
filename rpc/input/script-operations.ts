// src/rpc_definitions.ts
export interface ScriptOperations {
	listProjects: () => { projects: string[] };
	openProject: (projectPath: string) => void;
	testActionId: (testNonce: string) => { testOutput: string };
}
