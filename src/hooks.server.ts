import { pushSQLiteSchema } from 'drizzle-kit/api';

import { db } from '$lib/server/db';
import * as schema from '$lib/server/db/schema';
import type { ServerInit } from '@sveltejs/kit';

export async function migrateFromSchema() {
	const { apply } = await pushSQLiteSchema(schema, db);
	await apply();
}

export const init: ServerInit = async () => {
	await migrateFromSchema();
};
