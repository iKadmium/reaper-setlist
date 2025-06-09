import type { ScriptOperations } from '../../../../../rpc/input/script-operations';
import type { ReaperApiClient, ReaperCommand } from '../api';
import { ReaperStateCommandBuilder } from './abstract-reaper-state-accessor';
import { ScriptOperationKey, StateKeys, type SectionKey } from './reaper-state';

type ScriptOperation = keyof ScriptOperations;

export type ScriptOperationInput = {
	[K in keyof ScriptOperations]: keyof Parameters<ScriptOperations[K]>[0];
}[keyof ScriptOperations];

export type ScriptOperationOutput = {
	[K in keyof ScriptOperations]: keyof Awaited<ReturnType<ScriptOperations[K]>>;
}[keyof ScriptOperations];

export class ReaperScriptCommandBuilder extends ReaperStateCommandBuilder {
	constructor(
		protected readonly apiClient: ReaperApiClient,
		section: SectionKey
	) {
		super(section, apiClient);
	}

	getExtState(key: string): ReaperCommand {
		return this.getExtStateCommand(key);
	}

	setExtState(key: string, value: string, temp: boolean = false): ReaperCommand {
		return this.setExtStateCommand(key, value, temp);
	}

	setOperation(operation: string): ReaperCommand {
		return this.setExtState(ScriptOperationKey, operation, false);
	}
}
