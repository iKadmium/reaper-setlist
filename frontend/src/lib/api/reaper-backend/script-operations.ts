// src/rpc_definitions.ts
export interface ScriptOperations {
	listProjects: (inputs: {}) => Promise<{ projects: string[] }>;
	openProject: (inputs: { projectPath: string }) => Promise<void>;
	testActionId: (inputs: { testNonce: string }) => Promise<{ testOutput: string }>;
}
