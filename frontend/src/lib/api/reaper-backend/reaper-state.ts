export const ScriptOperationKey = 'Operation';

export const StateKeys = {
	ProjectRoot: 'ProjectRoot',
	ScriptActionId: 'ScriptActionId'
} as const;

export type StateKey = (typeof StateKeys)[keyof typeof StateKeys] | typeof ScriptOperationKey;

export const SectionKeys = {
	ReaperSetlist: 'ReaperSetlist',
	Songs: 'ReaperSetlist.Songs',
	Sets: 'ReaperSetlist.Sets'
};

export type SectionKey = (typeof SectionKeys)[keyof typeof SectionKeys];

export const KVStores = {
	Songs: 'Songs',
	Sets: 'Sets'
};

export type KVStoreName = (typeof KVStores)[keyof typeof KVStores];
