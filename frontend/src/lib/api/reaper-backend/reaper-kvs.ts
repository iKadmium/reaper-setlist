import { generateUUID } from "$lib/util";
import { KeyValueStore, type WithId } from "../key-value-store";
import type { KVStoreName, ReaperStateAccessor } from "./reaper-state";

export class ReaperKVS<TValue extends WithId<string>> extends KeyValueStore<string, TValue> {
    constructor(private readonly storeName: KVStoreName, private readonly accessor: ReaperStateAccessor) {
        super();
    }

    private async fetchAll(): Promise<Record<string, TValue>> {
        const raw = await this.accessor.getStoreItems(this.storeName);
        if (!raw) {
            return {};
        }
        const parsedItems = JSON.parse(raw) as Record<string, TValue>;
        return parsedItems;
    }

    private async save(items: Record<string, TValue>): Promise<void> {
        await this.accessor.setStoreItems(this.storeName, items);
    }

    async get(key: string): Promise<TValue | undefined> {
        const items = await this.fetchAll();
        return items[key];
    }

    async update(key: string, value: TValue): Promise<void> {
        const items = await this.fetchAll();
        items[key] = value;
        await this.save(items);
    }

    async add(value: Omit<TValue, 'id'>): Promise<TValue> {
        const items = await this.fetchAll();
        const key = generateUUID();
        const valueWithId = { ...value, id: key } as TValue;
        items[key] = valueWithId;
        await this.save(items);
        return valueWithId;
    }

    async delete(key: string): Promise<void> {
        const items = await this.fetchAll();
        delete items[key];
        await this.save(items);
    }

    async list(): Promise<Record<string, TValue>> {
        const items = await this.fetchAll();
        return items;
    }
}