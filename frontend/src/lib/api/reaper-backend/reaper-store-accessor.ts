import type { ReaperApiClient, ReaperCommand } from '../api';
import { ReaperStateCommandBuilder } from './abstract-reaper-state-accessor';
import type { KVStoreName } from './reaper-state';

const CHUNK_SIZE = 500;
const INDEX_KEY = '__index__';
const CONTINUATION_MARKER = '|C|';

export class ReaperStoreAccessor<TValue> extends ReaperStateCommandBuilder {
	private readonly apiClient: ReaperApiClient;
	constructor(section: KVStoreName, apiClient: ReaperApiClient) {
		super(section);
		this.apiClient = apiClient;
	}

	private getChunkKey(key: string, index: number): string {
		return `${key}.${index}`;
	}

	private async readChunked(key: string): Promise<string | undefined> {
		let chunks: string[] = [];
		let i = 0;
		while (true) {
			const chunkCommand = this.getExtStateCommand(key + '.' + i);
			const result = await this.apiClient.sendCommand(chunkCommand);
			const chunk = this.parseGetExtStateCommandResult(result);

			if (!chunk) break;
			if (chunk.endsWith(CONTINUATION_MARKER)) {
				chunks.push(chunk.slice(0, -CONTINUATION_MARKER.length));
				i++;
			} else {
				chunks.push(chunk);
				break;
			}
		}
		if (chunks.length === 0) return undefined;
		return chunks.join('');
	}

	private async writeChunked(key: string, value: string): Promise<void> {
		if (value.includes(CONTINUATION_MARKER)) {
			throw new Error(
				`Value to be stored contains the reserved continuation marker (${CONTINUATION_MARKER}).`
			);
		}
		const commands: ReaperCommand[] = [];
		const numChunks = Math.ceil(value.length / CHUNK_SIZE);
		for (let i = 0; i < numChunks; i++) {
			let chunk = value.slice(i * CHUNK_SIZE, (i + 1) * CHUNK_SIZE);
			if (i < numChunks - 1) chunk += CONTINUATION_MARKER;
			commands.push(this.setExtStateCommand(key + '.' + i, chunk, false));
		}
		let cleanupIndex = numChunks;
		while (true) {
			const chunk = await this.getExtStateCommand(key + '.' + cleanupIndex);
			if (!chunk) break;
			commands.push(this.setExtStateCommand(key + '.' + cleanupIndex, '', false));
			cleanupIndex++;
		}
		// do not use batch here, as the state was chunked to avoid exceeding the max batch size
		await Promise.all(commands.map((command) => this.apiClient.sendCommand(command)));
	}

	async getItem(key: string): Promise<TValue | undefined> {
		const chunkKey = this.getChunkKey(key, 0).replace(/\.0$/, '');
		const raw = await this.readChunked(chunkKey);
		if (!raw) return undefined;
		return JSON.parse(raw) as TValue;
	}

	async setItem(key: string, value: TValue): Promise<void> {
		const chunkKey = this.getChunkKey(key, 0).replace(/\.0$/, '');
		const raw = JSON.stringify(value);
		await this.writeChunked(chunkKey, raw);
	}

	async deleteItem(key: string): Promise<void> {
		const chunkKey = this.getChunkKey(key, 0).replace(/\.0$/, '');
		let i = 0;
		while (true) {
			const getChunkCommand = this.getExtStateCommand(chunkKey + '.' + i);
			const result = await this.apiClient.sendCommand(getChunkCommand);
			const chunk = this.parseGetExtStateCommandResult(result);
			if (!chunk) break;
			const deleteChunkCommand = this.setExtStateCommand(chunkKey + '.' + i, '', false);
			await this.apiClient.sendCommand(deleteChunkCommand);
			i++;
		}
	}

	async getItems(keys: string[]): Promise<Record<string, TValue | undefined>> {
		if (keys.length === 0) {
			const empty: Record<string, TValue | undefined> = {};
			return empty;
		}
		const out: Record<string, TValue | undefined> = {};
		// Prepare chunk keys for the first chunk of each key
		const chunk0Keys = keys.map((key) => this.getChunkKey(key, 0).replace(/\.0$/, ''));
		const batchKeys = chunk0Keys.map((k) => k + '.0');
		const chunk0Commands = batchKeys.map((k) => this.getExtStateCommand(k));
		const chunk0ResponsesRaw = await this.apiClient.sendCommands(chunk0Commands);
		const chunk0Responses = chunk0ResponsesRaw.map((r) => this.parseGetExtStateCommandResult(r));

		for (let idx = 0; idx < keys.length; idx++) {
			const key = keys[idx];
			let chunks: string[] = [];
			let chunk = chunk0Responses[idx];
			let i = 0;
			try {
				while (chunk) {
					if (chunk.endsWith(CONTINUATION_MARKER)) {
						chunks.push(chunk.slice(0, -CONTINUATION_MARKER.length));
						i++;
						const nextChunkKey = this.getChunkKey(key, i).replace(/\.0$/, '');
						const nextChunkCommand = this.getExtStateCommand(nextChunkKey + '.' + i);
						const chunkRaw = await this.apiClient.sendCommand(nextChunkCommand);
						chunk = this.parseGetExtStateCommandResult(chunkRaw);
					} else {
						chunks.push(chunk);
						break;
					}
				}
				out[key] = chunks.length > 0 ? (JSON.parse(chunks.join('')) as TValue) : undefined;
			} catch {
				out[key] = undefined;
			}
		}
		return out;
	}

	public async getIndex(): Promise<string[]> {
		const chunkKey = this.getChunkKey(INDEX_KEY, 0).replace(/\.0$/, '');
		const raw = await this.readChunked(chunkKey);
		const strings = JSON.parse(raw || '[]') as string[];
		return strings;
	}

	public async setIndex(index: string[]): Promise<void> {
		const chunkKey = this.getChunkKey(INDEX_KEY, 0).replace(/\.0$/, '');
		const raw = JSON.stringify(index);
		await this.writeChunked(chunkKey, raw);
	}
}
