import type { ReaperApiClient } from '../api';
import type { SectionKey } from './reaper-state';

export abstract class AbstractReaperStateAccessor {
	protected constructor(
		protected readonly section: SectionKey,
		protected readonly apiClient: ReaperApiClient
	) {}

	protected async getExtStateInternal(key: string): Promise<string> {
		const command = `GET/EXTSTATE/${this.section}/${key}`;
		const result = await this.apiClient.sendCommand(command);
		const lines = result.split('\n').filter((line) => line.trim() !== '');
		const value = lines[0].split('\t');
		return value[3];
	}

	protected async setExtStateInternal(
		key: string,
		value: string,
		temp: boolean = false
	): Promise<void> {
		const command = temp
			? `SET/EXTSTATE/${this.section}/${key}/${value}`
			: `SET/EXTSTATEPERSIST/${this.section}/${key}/${value}`;
		await this.apiClient.sendCommand(command);
	}

	// Add a batch fetch method to the abstract accessor
	public async fetchExtStateInternalBatch(keys: string[]): Promise<(string | undefined)[]> {
		const commands = keys.map((k) => `GET/EXTSTATE/${this.section}/${k}`);
		const responses = await this.apiClient.sendCommands(commands);
		const states = responses.map((response) => response.split('\t')[3]);
		return states;
	}
}
