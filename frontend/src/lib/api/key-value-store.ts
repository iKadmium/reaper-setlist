export interface WithId<T> {
	id: T;
}

export abstract class KeyValueStore<K extends string | number | symbol, V extends WithId<K>> {
	abstract get(key: K): Promise<V | undefined>;
	abstract update(key: K, value: V): Promise<void>;
	abstract add(value: Omit<V, 'id'>): Promise<V>;
	abstract delete(key: K): Promise<void>;
	abstract list(): Promise<Record<K, V>>;
}
