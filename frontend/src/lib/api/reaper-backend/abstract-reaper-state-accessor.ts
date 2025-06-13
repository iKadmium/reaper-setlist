import { GetStateCommand, SetStateCommand } from './commands';
import type { SectionKey } from './reaper-state';

export abstract class ReaperStateCommandBuilder {
	protected constructor(protected readonly section: SectionKey) {}

	protected getExtStateCommand(key: string): GetStateCommand {
		return new GetStateCommand(this.section, key);
	}

	protected setExtStateCommand(key: string, value: string, temp: boolean = false): SetStateCommand {
		return new SetStateCommand(this.section, key, value, temp);
	}
}
