import { drizzle } from 'drizzle-orm/libsql';
import { createClient } from '@libsql/client';
import * as schema from './schema';
import { env } from '$env/dynamic/private';

const client = createClient({ url: env.DATABASE_URL || 'file:data/db.sqlite' });

export const db = drizzle(client, {
	schema,
	casing: 'snake_case'
});
