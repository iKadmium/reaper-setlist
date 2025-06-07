import { svelteTesting } from '@testing-library/svelte/vite';
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import Icons from 'unplugin-icons/vite';

export default defineConfig({
	server: {
		proxy: {
			'/_/': {
				target: 'http://192.168.0.42:8080/',
				changeOrigin: true,
				configure: (proxy, _options) => {
					proxy.on("error", (err, _req, _res) => {
						console.log("proxy error", err);
					});
					proxy.on("proxyReq", (proxyReq, req, _res) => {
						console.log(
							"Sending Request:",
							req.method,
							req.url,
							" => TO THE TARGET =>  ",
							proxyReq.method,
							proxyReq.protocol,
							proxyReq.host,
							proxyReq.path,
							JSON.stringify(proxyReq.getHeaders()),
						);
					});
					proxy.on("proxyRes", (proxyRes, req, _res) => {
						console.log(
							"Received Response from the Target:",
							proxyRes.statusCode,
							req.url,
							JSON.stringify(proxyRes.headers),
						);
					});
				}

			}
		}
	},

	plugins: [
		sveltekit(),
		Icons({
			compiler: 'svelte'
		})
	],

	test: {
		workspace: [
			{
				extends: './vite.config.ts',
				plugins: [svelteTesting()],

				test: {
					name: 'client',
					environment: 'jsdom',
					clearMocks: true,
					include: ['src/**/*.svelte.{test,spec}.{js,ts}'],
					exclude: ['src/lib/server/**'],
					setupFiles: ['./vitest-setup-client.ts']
				}
			},
			{
				extends: './vite.config.ts',

				test: {
					name: 'server',
					environment: 'node',
					include: ['src/**/*.{test,spec}.{js,ts}'],
					exclude: ['src/**/*.svelte.{test,spec}.{js,ts}']
				}
			}
		]
	}
});
