import type { ReaperApiClient } from '../api';
import { StateKeys, type OperationKey, type SectionKey, type StateKey } from './reaper-state';
import { AbstractReaperStateAccessor } from './abstract-reaper-state-accessor';

export class ReaperMiscStateAccessor extends AbstractReaperStateAccessor {
	constructor(
		protected readonly apiClient: ReaperApiClient,
		section: SectionKey
	) {
		super(section, apiClient);
	}

	async getExtState(key: StateKey): Promise<string> {
		return this.getExtStateInternal(key);
	}

	async setExtState(key: StateKey, value: string, temp: boolean = false): Promise<void> {
		return this.setExtStateInternal(key, value, temp);
	}

	async SetOperation(operation: OperationKey): Promise<void> {
		await this.setExtState(StateKeys.Operation, operation, false);
	}
}
