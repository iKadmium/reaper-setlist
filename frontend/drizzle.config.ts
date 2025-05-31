import { defineConfig } from 'drizzle-kit';

export default defineConfig({
	schema: './src/lib/server/db/schema.ts',

	dbCredentials: {
		url: process.env.DATABASE_URL || 'file:data/db.sqlite'
	},

	verbose: true,
	strict: true,
	dialect: 'sqlite'
});
