import { generateUUID } from '$lib/util';
import { KeyValueStore, type WithId } from '../key-value-store';
import type { ReaperStoreAccessor } from './reaper-store-accessor';

export class ReaperKVS<TValue extends WithId<string>> extends KeyValueStore<string, TValue> {
	constructor(private readonly accessor: ReaperStoreAccessor<TValue>) {
		super();
	}

	private async fetchIndex(): Promise<string[]> {
		const index = await this.accessor.getIndex();
		return index ?? [];
	}

	private async saveIndex(ids: string[]): Promise<void> {
		await this.accessor.setIndex(ids);
	}

	private async fetchById(id: string): Promise<TValue | undefined> {
		return this.accessor.getItem(id);
	}

	private async saveById(id: string, value: TValue): Promise<void> {
		await this.accessor.setItem(id, value);
	}

	private async deleteById(id: string): Promise<void> {
		await this.accessor.deleteItem(id);
	}

	async get(key: string): Promise<TValue | undefined> {
		return this.fetchById(key);
	}

	async update(key: string, value: TValue): Promise<void> {
		const ids = await this.fetchIndex();
		if (!ids.includes(key)) {
			ids.push(key);
			await this.saveIndex(ids);
		}
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
		const ids = await this.fetchIndex();
		const result: Record<string, TValue> = {};
		const maxChunkSize = 1900;

		let currentChunk: string[] = [];
		let currentChunkSize = 0;

		for (const id of ids) {
			const idLength = id.length;

			// If adding this ID would exceed the limit, process the current chunk
			if (currentChunkSize + idLength > maxChunkSize && currentChunk.length > 0) {
				const items = await this.accessor.getItems(currentChunk);
				for (const chunkId of currentChunk) {
					const value = items[chunkId];
					if (value) result[chunkId] = value;
				}

				// Reset for next chunk
				currentChunk = [];
				currentChunkSize = 0;
			}

			// Add the current ID to the chunk
			currentChunk.push(id);
			currentChunkSize += idLength;
		}

		// Process the final chunk if it has any items
		if (currentChunk.length > 0) {
			const items = await this.accessor.getItems(currentChunk);
			for (const id of currentChunk) {
				const value = items[id];
				if (value) result[id] = value;
			}
		}

		return result;
	}
}
