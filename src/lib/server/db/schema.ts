import { integer, sqliteTable, text } from 'drizzle-orm/sqlite-core';

export const setlist = sqliteTable('setlist', {
	id: integer().primaryKey({ autoIncrement: true }),
	venue: text(),
	date: integer({ mode: 'timestamp' })
})

export const song = sqliteTable('song', {
	id: integer('id').primaryKey({ autoIncrement: true }),
	name: text('name'),
	length: integer(),
	path: text()
})

export const setlist_song = sqliteTable('setlist_song', {
	id: integer().primaryKey({ autoIncrement: true }),
	setlistId: integer('setlist_id').references(() => setlist.id),
	songId: integer('song_id').references(() => song.id),
	order: integer()
})