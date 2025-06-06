import { KeyValueStore, type WithId } from "../key-value-store";
import type { ReaperStateAccessor } from "./reaper-state";

export class ReaperKVS<TValue extends WithId<string>> extends KeyValueStore<string, TValue> {
    constructor(private readonly storeName: string, private readonly accessor: ReaperStateAccessor) {
        super();
    }

    private chunkString(str: string, chunkSize: number): string[] {
        const result: string[] = [];
        for (let i = 0; i < str.length; i += chunkSize) {
            result.push(str.slice(i, i + chunkSize));
        }
        return result;
    }

    private async fetchAll(): Promise<Record<string, TValue>> {
        const items: Record<string, TValue> = {};
        const lengthKey = `${this.storeName}_length`;
        const lengthString = await this.accessor.getExtState(lengthKey);
        console.log(`Length string for ${this.storeName}:`, lengthString);
        if (!lengthString) {
            return items; // No items found
        }
        const length = parseInt(lengthString, 10);
        const chunkPromises = Array.from({ length }, (_, index) => {
            const chunkKey = `${this.storeName}_chunk_${index}`;
            return this.accessor.getExtState(chunkKey);
        });
        const chunks = await Promise.all(chunkPromises);
        const decodedChunks = chunks.map(chunk => decodeURIComponent(chunk));
        const combinedString = decodedChunks.join('');
        const parsedItems = JSON.parse(combinedString) as Record<string, TValue>;
        Object.assign(items, parsedItems);
        return items;
    }

    private async save(items: Record<string, TValue>): Promise<void> {
        const itemsString = JSON.stringify(items);
        const encoded = encodeURIComponent(itemsString);
        const chunks = this.chunkString(encoded, 512);
        //set the length of the chunks and then the chunks themselves
        const lengthKey = `${this.storeName}_length`;
        await this.accessor.setExtState(lengthKey, String(chunks.length), false);
        const chunkPromises = chunks.map((chunk, index) => {
            const chunkKey = `${this.storeName}_chunk_${index}`;
            return this.accessor.setExtState(chunkKey, chunk, false);
        });
        await Promise.all(chunkPromises);
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
        const key = crypto.randomUUID();
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