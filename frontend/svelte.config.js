// @ts-check
import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://svelte.dev/docs/kit/integrations
	// for more information about preprocessors
	preprocess: vitePreprocess(),

	kit: {
		router: {
			type: 'hash'
		},

		adapter: adapter({
			pages: 'build',
			assets: 'build',
			precompress: false
		}),

		paths: {
			base: process.env.NODE_ENV === 'production' ? '/reaper-setlist' : ''
		},

		prerender: {
			entries: ['*']
		},

		files: {
			assets: 'static'
		}
	},

	compilerOptions: {
		runes: true
	}
};

export default config;
