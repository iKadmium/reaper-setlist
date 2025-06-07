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
			fallback: 'index.html'
		}),
		paths: {
			base: '/setlist'
		}
	},

	compilerOptions: {
		runes: true
	}
};

export default config;
