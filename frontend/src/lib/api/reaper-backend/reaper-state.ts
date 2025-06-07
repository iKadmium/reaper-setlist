import type { ReaperApiClient } from '../api';

export const StateKeys = {
	Operation: 'Operation',
	ProjectRoot: 'ProjectRoot',
	ProjectPath: 'ProjectPath',
	ScriptOutput: 'ScriptOutput',
	ScriptActionId: 'ScriptActionId',
	SongsLength: 'SongsLength',
	SetsLength: 'SetsLength',
	TestInput: 'TestInput'
} as const;

export type StateKey = (typeof StateKeys)[keyof typeof StateKeys];

export const SectionKeys = {
	ReaperSetlist: 'ReaperSetlist',
	Songs: 'ReaperSetlist.Songs',
	Sets: 'ReaperSetlist.Sets'
};

export type SectionKey = (typeof SectionKeys)[keyof typeof SectionKeys];

export const OperationKeys = {
	ListProjects: 'ListProjects',
	OpenProject: 'OpenProject',
	TestActionId: 'TestActionId'
};

export type OperationKey = (typeof OperationKeys)[keyof typeof OperationKeys];

export const KVStores = {
	Songs: 'Songs',
	Sets: 'Sets'
};

export type KVStoreName = (typeof KVStores)[keyof typeof KVStores];
