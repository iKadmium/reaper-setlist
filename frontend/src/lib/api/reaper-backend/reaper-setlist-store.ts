import type { Setlist } from "$lib/models/setlist";
import type { SetlistsStore } from "../api";
import { ReaperKVS } from "./reaper-kvs";

export class ReaperSetlistStoreImpl extends ReaperKVS<Setlist> implements SetlistsStore {
    async deleteSongFromSets(id: string): Promise<void> {
        await this.updateMany(entries => {
            const updatedEntries: Record<string, Setlist> = {};
            for (const [key, setlist] of Object.entries(entries)) {
                // Filter out the song from the setlist
                setlist.songs = setlist.songs.filter(songId => songId !== id);
                updatedEntries[key] = setlist;
            }
            return updatedEntries;
        });
    }

}
