export const StateKeys = {
	Operation: "Operation",
	ProjectRoot: "ProjectRoot",
	ProjectPath: "ProjectPath",
	ScriptOutput: "ScriptOutput",
	ScriptActionId: "ScriptActionId",
	SongsLength: "SongsLength",
	SetsLength: "SetsLength",
	TestInput: "TestInput",
} as const;

export type StateKey = typeof StateKeys[keyof typeof StateKeys];

export const SectionKeys = {
	ReaperSetlist: "ReaperSetlist"
}

export type SectionKey = typeof SectionKeys[keyof typeof SectionKeys];

export const OperationKeys = {
	ListProjects: "ListProjects",
	OpenProject: "OpenProject",
	TestActionId: "TestActionId",
}

export type OperationKey = typeof OperationKeys[keyof typeof OperationKeys];

export const KVStores = {
	Songs: "Songs",
	Sets: "Sets",
}

export type KVStoreName = typeof KVStores[keyof typeof KVStores];

export class ReaperStateAccessor {
	constructor(
		private readonly section: SectionKey,
		private readonly urlRoot: string,
		private readonly fetch: typeof globalThis.fetch
	) { }

	private async getExtStateInternal(key: string): Promise<string> {
		const response = await this.fetch(`${this.urlRoot}/GET/EXTSTATE/${this.section}/${key}`, {
			method: 'GET'
		});

		if (response.ok) {
			const resp = await response.text();
			const lines = resp.split('\n');
			const parts = lines[0].split('\t');
			if (parts.length < 4) {
				throw new Error(`Unexpected response format for key ${key}: ${resp}`);
			}
			return parts[3]; // The value is the fourth part
		}
		throw new Error(`Failed to get key ${key}: ${response.statusText}`);
	}

	public async setExtStateInternal(key: string, value: string, temp: boolean = false): Promise<void> {
		const url = temp
			? `${this.urlRoot}/SET/EXTSTATE/${this.section}/${key}/${value}`
			: `${this.urlRoot}/SET/EXTSTATEPERSIST/${this.section}/${key}/${value}`;
		const response = await this.fetch(url, {
			method: 'GET'
		});

		if (!response.ok) {
			throw new Error(`Failed to set key ${key}: ${response.statusText}`);
		}
	}

	public async getExtState(key: StateKey): Promise<string> {
		return this.getExtStateInternal(key);
	}

	public async setExtState(key: StateKey, value: string, temp: boolean = false): Promise<void> {
		return this.setExtStateInternal(key, value, temp);
	}

	public async SetOperation(operation: OperationKey): Promise<void> {
		await this.setExtState(StateKeys.Operation, operation, false);
	}

	public async getStoreItems<T>(name: KVStoreName): Promise<string> {
		const lengthKey = `${name}Length`;
		const lengthString = await this.getExtStateInternal(lengthKey);
		console.log(`Length string for ${name}:`, lengthString);
		if (!lengthString) {
			return ''; // No items found
		}
		const length = parseInt(lengthString, 10);
		const chunkPromises = Array.from({ length }, (_, index) => {
			const chunkKey = `${name}Chunk${index}`;
			return this.getExtStateInternal(chunkKey);
		});
		const chunks = await Promise.all(chunkPromises);
		const decodedChunks = chunks.map(chunk => decodeURIComponent(chunk));
		const combinedString = decodedChunks.join('');
		return combinedString;
	}

	public async setStoreItems<T>(name: KVStoreName, items: Record<string, T>): Promise<void> {
		const itemsString = JSON.stringify(items);
		const chunkSize = 512; // Size of each chunk in characters
		const chunks = [];
		for (let i = 0; i < itemsString.length; i += chunkSize) {
			const slice = itemsString.slice(i, i + chunkSize);
			const encoded = encodeURIComponent(slice);
			chunks.push(encoded);
		}
		const lengthKey = `${name}Length`;
		await this.setExtStateInternal(lengthKey, String(chunks.length), false);
		const chunkPromises = chunks.map((chunk, index) => {
			const chunkKey = `${name}Chunk${index}`;
			return this.setExtStateInternal(chunkKey, chunk, false);
		});
		await Promise.all(chunkPromises);
	}
}
