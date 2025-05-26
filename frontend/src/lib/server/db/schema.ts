import { integer, sqliteTable, text } from 'drizzle-orm/sqlite-core';

export const setlists = sqliteTable('setlist', {
	id: integer().primaryKey({ autoIncrement: true }),
	venue: text().notNull(),
	date: integer({ mode: 'timestamp' }).notNull()
});

export const songs = sqliteTable('song', {
	id: integer().primaryKey({ autoIncrement: true }),
	name: text().notNull(),
	length: integer().notNull()
});

export const setlist_songs = sqliteTable('setlist_song', {
	id: integer().primaryKey({ autoIncrement: true }),
	setlistId: integer('setlist_id')
		.references(() => setlists.id)
		.notNull(),
	songId: integer('song_id')
		.references(() => songs.id)
		.notNull(),
	order: integer().notNull()
});

export type SetlistInsert = typeof setlists.$inferInsert;
export type SongInsert = typeof songs.$inferInsert;
export type SetlistSongInsert = typeof setlist_songs.$inferInsert;

export type Setlist = typeof setlists.$inferSelect;
export type Song = typeof songs.$inferSelect;
export type SetlistSong = typeof setlist_songs.$inferSelect;

export interface SetlistDenormalized {
	id?: number;
	venue: string;
	date: number;
	songs: number[];
}
