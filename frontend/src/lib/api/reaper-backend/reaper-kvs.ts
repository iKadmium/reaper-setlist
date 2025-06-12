import { generateUUID } from '$lib/util';
import { KeyValueStore, type WithId } from '../key-value-store';
import { GetStateCommand, SetStateCommand } from './commands';
import type { ReaperApiClient } from './reaper-api';
import type { ReaperRpcClient } from './reaper-rpc-client.svelte';
import { type SectionKey } from './reaper-state';

const CHUNK_SIZE = 500;
const INDEX_KEY = '__index__';

export class ReaperKVS<TValue extends WithId<string>> extends KeyValueStore<string, TValue> {
	constructor(
		private readonly apiClient: ReaperApiClient,
		private readonly scriptClient: ReaperRpcClient,
		private readonly sectionKey: SectionKey
	) {
		super();
	}

	private async fetchIndex(): Promise<string[]> {
		const command = new GetStateCommand(this.sectionKey, INDEX_KEY);
		const index = await this.apiClient.executeCommand(command);
		if (!index) {
			return [];
		}
		return JSON.parse(index) as string[];
	}

	private async saveData<T>(key: string, item: T): Promise<void> {
		const length = JSON.stringify(item).length;
		if (length <= CHUNK_SIZE) {
			await this.apiClient.executeCommand(
				new SetStateCommand(this.sectionKey, key, JSON.stringify(item))
			);
		} else {
			await this.scriptClient.writeChunkedData(this.sectionKey, key, item);
		}
	}

	private async saveIndex(ids: string[]): Promise<void> {
		await this.saveData(INDEX_KEY, ids);
	}

	private async fetchById(id: string): Promise<TValue | undefined> {
		const command = new GetStateCommand(this.sectionKey, id);
		const data = await this.apiClient.executeCommand(command);
		return data ? (JSON.parse(data) as TValue) : undefined;
	}

	private async saveById(id: string, value: TValue): Promise<void> {
		await this.saveData(id, value);
	}

	private async deleteById(id: string): Promise<void> {
		await this.scriptClient.deleteState(this.sectionKey, id);
	}

	async get(key: string): Promise<TValue | undefined> {
		return this.fetchById(key);
	}

	async update(key: string, value: TValue): Promise<void> {
		await this.saveById(key, value);
	}

	async add(value: Omit<TValue, 'id'>): Promise<TValue> {
		const key = generateUUID();
		const valueWithId = { ...value, id: key } as TValue;
		await this.saveById(key, valueWithId);
		const ids = await this.fetchIndex();
		ids.push(key);
		await this.saveIndex(ids);
		return valueWithId;
	}

	async delete(key: string): Promise<void> {
		await this.deleteById(key);
		const ids = await this.fetchIndex();
		const newIds = ids.filter((id) => id !== key);
		await this.saveIndex(newIds);
	}

	async list(): Promise<Record<string, TValue>> {
		const getIndexCommand = new GetStateCommand(this.sectionKey, INDEX_KEY);
		const index = await this.apiClient.executeCommand(getIndexCommand);
		if (!index) {
			return {};
		}
		const ids = JSON.parse(index) as string[];
		const items: Record<string, TValue> = {};
		const getCommands = ids.map((id) => new GetStateCommand(this.sectionKey, id));
		const results = await this.apiClient.executeCommands(getCommands);
		for (const result of results) {
			if (result) {
				const item = JSON.parse(result) as TValue;
				items[item.id] = item;
			}
		}
		return items;
	}
}
