// src/rpc_definitions.ts
export interface ScriptOperations {
	listProjects: () => Promise<{ projects: string[] }>;
	openProject: (projectPath: string) => Promise<void>;
	testActionId: (testNonce: string) => Promise<{ testOutput: string }>;
}
