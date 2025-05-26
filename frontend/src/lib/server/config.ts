import { writeFile, readFile } from 'node:fs/promises';
import path from 'node:path';
import { env } from 'process';

export interface Config {
	reaperUrl: string;
	folderPath: string;
}

const configFilePath = path.resolve(env.CONFIG_FILE_PATH || 'data/config.json');

export async function getConfig(): Promise<Config> {
	try {
		const data = await readFile(configFilePath, 'utf-8');
		return JSON.parse(data) as Config;
	} catch (error) {
		if ((error as NodeJS.ErrnoException).code === 'ENOENT') {
			// Return an empty config if the file does not exist
			return {
				reaperUrl: '',
				folderPath: ''
			};
		}
		throw error;
	}
}

export async function setConfig(newConfig: Config): Promise<void> {
	await writeFile(configFilePath, JSON.stringify(newConfig, null, 2), 'utf-8');
}
