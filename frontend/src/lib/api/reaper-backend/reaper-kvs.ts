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
		const chunkSize = 10;
		for (let i = 0; i < ids.length; i += chunkSize) {
			const chunkIds = ids.slice(i, i + chunkSize);
			const items = await this.accessor.getItems(chunkIds);
			for (const id of chunkIds) {
				const value = items[id];
				if (value) result[id] = value;
			}
		}
		return result;
	}
}
