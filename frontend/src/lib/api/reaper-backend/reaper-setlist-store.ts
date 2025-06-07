import type { Setlist } from '$lib/models/setlist';
import type { SetlistsStore } from '../api';
import { ReaperKVS } from './reaper-kvs';

export class ReaperSetlistStoreImpl extends ReaperKVS<Setlist> implements SetlistsStore {
	async deleteSongFromSets(id: string): Promise<void> {
		const setlists = await this.list();
		const updates: Promise<void>[] = [];
		for (const setlist of Object.values(setlists)) {
			if (setlist.songs.includes(id)) {
				setlist.songs = setlist.songs.filter((songId) => songId !== id);
				updates.push(this.update(setlist.id, setlist));
			}
		}
		await Promise.all(updates);
	}
}
