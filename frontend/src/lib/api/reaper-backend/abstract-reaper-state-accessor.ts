import type { ReaperApiClient, ReaperCommand } from '../api';
import type { SectionKey } from './reaper-state';

export abstract class ReaperStateCommandBuilder {
	protected constructor(
		protected readonly section: SectionKey,
		protected readonly apiClient: ReaperApiClient
	) {}

	protected getExtStateCommand(key: string): ReaperCommand {
		const command = `GET/EXTSTATE/${this.section}/${key}` as ReaperCommand;
		return command;
	}

	protected setExtStateCommand(key: string, value: string, temp: boolean = false): ReaperCommand {
		const command = temp
			? (`SET/EXTSTATE/${this.section}/${key}/${value}` as ReaperCommand)
			: (`SET/EXTSTATEPERSIST/${this.section}/${key}/${value}` as ReaperCommand);
		return command;
	}

	protected parseGetExtStateCommandResult(result: string): string {
		const lines = result.split('\n');
		const tabs = lines[0].split('\t');
		return tabs[3];
	}
}
