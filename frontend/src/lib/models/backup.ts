import type { Database } from './database';
import type { Setlist } from './setlist';
import type { Song } from './song';

export interface Backup {
	songs: Database<Song>;
	sets: Database<Setlist>;
}
