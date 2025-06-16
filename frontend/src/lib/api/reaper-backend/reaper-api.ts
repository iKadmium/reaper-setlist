import type { ReaperMarker } from '$lib/models/reaper-marker';
import type { ReaperTransport } from '$lib/models/reaper-transport';
import { Commands, type CommandResults, type ReaperCommand } from './commands';

const MAX_URL_LENGTH = 600;

export class ReaperApiClient {
	private readonly urlRoot: string;
	private readonly fetch: typeof globalThis.fetch;

	constructor(urlRoot: string, fetch: typeof globalThis.fetch = globalThis.fetch) {
		this.urlRoot = urlRoot;
		this.fetch = fetch;
	}

	// New type-safe command execution
	async executeCommand<TReturn, TInput, TResponse extends string | undefined>(
		command: ReaperCommand<TReturn, TInput, TResponse>
	): Promise<TReturn> {
		const [response] = await this.executeCommands([command] as const);
		return response;
	}

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	async executeCommands<T extends readonly ReaperCommand<any, any, any>[]>(
		commands: T
	): Promise<CommandResults<T>> {
		const commandStrings = await Promise.all(commands.map((cmd) => cmd.getCommandString()));
		const response = await this.sendRawCommands(commandStrings);

		// Parse responses for each command, preserving type information
		const results = this.parseMultiCommandResponse(commands, response);
		return results;
	}

	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	private parseMultiCommandResponse<T extends readonly ReaperCommand<any, any, any>[]>(
		commands: T,
		response: string[]
	): CommandResults<T> {
		const results: unknown[] = [];
		let responseIndex = 0;

		for (const command of commands) {
			if (!command.getResponseMarker()) {
				results.push(void 0);
				continue; // Skip commands without a response type
			}

			const commandResponse = response[responseIndex];
			if (commandResponse.length === 0) {
				throw new Error(`Empty response for command: ${command.getCommandString()}`);
			}

			const commandResponseType = commandResponse.split('\t')[0];
			if (commandResponseType !== command.getResponseMarker()) {
				throw new Error(
					`Unexpected response type for command ${command.getCommandString()}: expected ${command.getResponseMarker()}, got ${commandResponseType}`
				);
			}

			if (command.getResponseMarker() === 'MARKER_LIST') {
				const result = command.parseResponse(response.slice(responseIndex));
				const markers = result as ReaperMarker[];
				results.push(result);
				responseIndex += markers.length + 1;
			} else {
				const result = command.parseResponse(commandResponse);
				results.push(result);
			}

			responseIndex++;
		}

		// TypeScript can now properly infer the tuple type
		return results as CommandResults<T>;
	}

	// Legacy methods for backward compatibility
	async sendCommand(command: string): Promise<string[]> {
		return this.sendRawCommand(command);
	}

	async sendCommands(commands: string[]): Promise<string[]> {
		return this.sendRawCommands(commands);
	}

	// High-level API methods using new command system
	async getTransport(): Promise<ReaperTransport> {
		return this.executeCommand(Commands.transport());
	}

	async goToStart(): Promise<ReaperTransport> {
		const [_, transport] = await this.executeCommands([
			Commands.goToStart(),
			Commands.transport()
		] as const);
		return transport;
	}

	async play(): Promise<ReaperTransport> {
		const [, transport] = await this.executeCommands([
			Commands.play(),
			Commands.transport()
		] as const);
		return transport;
	}

	async pause(): Promise<ReaperTransport> {
		const [, transport] = await this.executeCommands([
			Commands.pause(),
			Commands.transport()
		] as const);
		return transport;
	}

	async stop(): Promise<ReaperTransport> {
		const [, transport] = await this.executeCommands([
			Commands.stop(),
			Commands.transport()
		] as const);
		return transport;
	}

	async record(): Promise<ReaperTransport> {
		const [, transport] = await this.executeCommands([
			Commands.record(),
			Commands.transport()
		] as const);
		return transport;
	}

	async closeTab(): Promise<void> {
		await this.executeCommand(Commands.closeTab());
	}

	async newTab(): Promise<void> {
		await this.executeCommand(Commands.newTab());
	}

	async closeAllTabs(): Promise<void> {
		await this.executeCommand(Commands.closeAllTabs());
	}

	async nextTab(): Promise<{ markers: ReaperMarker[]; transport: ReaperTransport }> {
		const [, transport, markers] = await this.executeCommands([
			Commands.nextTab(),
			Commands.transport(),
			Commands.markers()
		] as const);
		return { markers, transport };
	}

	async previousTab(): Promise<{ markers: ReaperMarker[]; transport: ReaperTransport }> {
		const [, transport, markers] = await this.executeCommands([
			Commands.previousTab(),
			Commands.transport(),
			Commands.markers()
		] as const);
		return { markers, transport };
	}

	async getMarkers(): Promise<ReaperMarker[]> {
		return this.executeCommand(Commands.markers());
	}

	async goToMarker(markerId: number): Promise<ReaperTransport> {
		const [_, transport] = await this.executeCommands([
			Commands.goToMarker(markerId),
			Commands.transport()
		] as const);
		return transport;
	}

	/**
	 * Demonstration method showing Promise.all style typing with mixed return types
	 * Each element in the returned tuple has its specific type, not a union type
	 */
	async playAndGetFullState(): Promise<{
		playResult: void;
		transport: ReaperTransport;
		markers: ReaperMarker[];
	}> {
		// Execute multiple commands with different return types
		const [playResult, transport, markers] = await this.executeCommands([
			Commands.play(), // Returns void
			Commands.transport(), // Returns ReaperTransport
			Commands.markers() // Returns ReaperMarker[]
		] as const);

		// TypeScript now knows the exact type of each element:
		// playResult is void (not void | ReaperTransport | ReaperMarker[])
		// transport is ReaperTransport (not void | ReaperTransport | ReaperMarker[])
		// markers is ReaperMarker[] (not void | ReaperTransport | ReaperMarker[])

		return { playResult, transport, markers };
	}

	// Private helper methods for raw HTTP communication
	private async sendRawCommand(command: string): Promise<string[]> {
		const result = await this.fetch(`${this.urlRoot}/${command}`, {
			method: 'GET'
		});
		if (!result.ok) {
			throw new Error(`Failed to send command ${command}: ${result.statusText}`);
		}
		const content = await result.text();
		const lines = content.split('\n').filter((line) => line.trim() !== '');
		return lines;
	}

	private async sendRawCommands(commands: string[]): Promise<string[]> {
		if (commands.length === 0) {
			return [];
		}

		const allResults: string[] = [];
		const batches = this.batchCommandsByUrlLength(commands);

		for (const batch of batches) {
			const url = `${this.urlRoot}/${batch.join(';')}`;

			const result = await this.fetch(url, {
				method: 'GET'
			});
			if (!result.ok) {
				throw new Error(`Failed to send commands ${batch.join(',')}: ${result.statusText}`);
			}
			const text = await result.text();
			const batchResults = text.split('\n').slice(0, -1);
			allResults.push(...batchResults);
		}

		return allResults;
	}

	private batchCommandsByUrlLength(commands: string[]): string[][] {
		const batches: string[][] = [];
		let currentBatch: string[] = [];
		let currentLength = this.urlRoot.length;

		for (const command of commands) {
			// Calculate length if we add this command
			const separator = currentBatch.length > 0 ? ';' : '';
			const additionalLength = separator.length + command.length;

			// If adding this command would exceed the limit, start a new batch
			if (currentLength + additionalLength > MAX_URL_LENGTH && currentBatch.length > 0) {
				batches.push([...currentBatch]);
				currentBatch = [command];
				currentLength = this.urlRoot.length + command.length;
			} else {
				currentBatch.push(command);
				currentLength += additionalLength;
			}
		}

		// Add the final batch if it has commands
		if (currentBatch.length > 0) {
			batches.push(currentBatch);
		}

		return batches;
	}
}
