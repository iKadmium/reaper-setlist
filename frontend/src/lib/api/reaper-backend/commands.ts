import type { ReaperMarker } from '$lib/models/reaper-marker';
import type { ReaperTransport } from '$lib/models/reaper-transport';
import { configuration } from '$lib/stores/configuration.svelte';
import { parseTransportString } from '$lib/util';
import { ScriptOperationKey, SectionKeys } from './reaper-state';

// Base command interface
export interface ReaperCommand<TReturn, TInput, TMarker extends string | undefined> {
    parseResponse(response: TInput): TReturn;
    getCommandString(): Promise<string>;
    getResponseMarker(): TMarker;
}

// Improved utility type for extracting return types from command arrays
// This ensures proper tuple typing like Promise.all
export type CommandResults<T extends readonly ReaperCommand<any, any, any>[]> = {
    readonly [K in keyof T]: T[K] extends ReaperCommand<infer TReturn, infer TInput, infer TMarker> ? TReturn : never;
};

// Abstract base class for common command functionality
abstract class BaseCommand<TReturn, TInput, TMarker extends string | undefined> implements ReaperCommand<TReturn, TInput, TMarker> {
    abstract parseResponse(response: TInput): TReturn;
    abstract getCommandString(): Promise<string>;
    abstract getResponseMarker(): TMarker;
}

// Command implementations

export class TransportCommand extends BaseCommand<ReaperTransport, string, string> {
    parseResponse(response: string): ReaperTransport {
        if (!response) {
            throw new Error('Empty transport response');
        }
        return parseTransportString(response);
    }

    getResponseMarker(): string {
        return 'TRANSPORT';
    }

    async getCommandString(): Promise<string> {
        return Promise.resolve('TRANSPORT');
    }
}

export class MarkersCommand extends BaseCommand<ReaperMarker[], string[], string> {
    parseResponse(response: string[]): ReaperMarker[] {
        const markers: ReaperMarker[] = [];
        for (const line of response) {
            if (line.startsWith("MARKER_LIST")) {
                continue;
            }
            if (line.startsWith("MARKER_LIST_END")) {
                break;
            }
            const parts = line.split('\t');
            if (parts.length < 4) {
                throw new Error(`Invalid marker line: ${line}`);
            } // Skip invalid lines
            const marker: ReaperMarker = {
                id: parseInt(parts[2], 10),
                name: parts[1],
                position: parseFloat(parts[3])
            };
            markers.push(marker);
        }
        return markers;
    }

    getResponseMarker(): string {
        return 'MARKER_LIST';
    }

    async getCommandString(): Promise<string> {
        return Promise.resolve('MARKER');
    }

}

abstract class VoidCommand extends BaseCommand<void, never, undefined> {
    parseResponse(_response: never): void { }
    getResponseMarker(): undefined { return undefined; }
}

// Specific action commands (void commands)
export class GoToStartCommand extends VoidCommand {
    getCommandString(): Promise<string> {
        return Promise.resolve('40042');
    }
}

export class NewTabCommand extends VoidCommand {
    getCommandString(): Promise<string> {
        return Promise.resolve('40859');
    }
}

export class CloseAllTabsCommand extends VoidCommand {
    getCommandString(): Promise<string> {
        return Promise.resolve('40860');
    }
}

export class NextTabCommand extends VoidCommand {
    getCommandString(): Promise<string> {
        return Promise.resolve('40861');
    }
}

export class PreviousTabCommand extends VoidCommand {
    getCommandString(): Promise<string> {
        return Promise.resolve('40862');
    }
}

export class PlayCommand extends VoidCommand {
    getCommandString(): Promise<string> {
        return Promise.resolve('1007');
    }
}

export class PauseCommand extends VoidCommand {
    getCommandString(): Promise<string> {
        return Promise.resolve('1008');
    }
}

export class StopCommand extends VoidCommand {
    getCommandString(): Promise<string> {
        return Promise.resolve('1016');
    }
}

export class RecordCommand extends VoidCommand {
    getCommandString(): Promise<string> {
        return Promise.resolve('1013');
    }
}

export class RunScriptCommand extends VoidCommand {
    async getCommandString(): Promise<string> {
        await configuration.ensureInitialized();
        if (!configuration.scriptActionId) {
            throw new Error('Script action ID is not set. Please configure it in the settings.');
        }
        return configuration.scriptActionId;
    }
}

export class GoToMarkerCommand extends VoidCommand {
    constructor(private readonly markerId: number) { super(); }

    async getCommandString(): Promise<string> {
        return Promise.resolve(`SET/POS_STR/m${this.markerId}`);
    }
}

export class SetStateCommand extends VoidCommand {
    constructor(private readonly section: string, private readonly key: string, private readonly value: string, private readonly persist: boolean = false) {
        super();
    }

    async getCommandString(): Promise<string> {
        const command = this.persist ? 'SET/EXTSTATEPERSIST' : 'SET/EXTSTATE';
        return Promise.resolve(`${command}/${this.section}/${this.key}/${this.value}`);
    }
}

export class SetOperationCommand extends SetStateCommand {
    constructor(operation: string) {
        super(SectionKeys.ReaperSetlist, ScriptOperationKey, operation, false);
    }
}

export class GetStateCommand extends BaseCommand<string | undefined, string, string> {
    constructor(private readonly section: string, private readonly key: string, private readonly temp: boolean = true) { super(); }

    getCommandString(): Promise<string> {
        const commandType = this.temp ? 'GET/EXTSTATE' : 'GET/EXTSTATE_PERSIST';
        return Promise.resolve(`${commandType}/${this.section}/${this.key}`);
    }

    parseResponse(response: string): string | undefined {
        if (!response || response.trim() === '') {
            return undefined; // No value set
        }
        const line = response.trim();
        const parts = line.split('\t');

        if (parts.length === 4 && parts[0] === "EXTSTATE" && parts[1] === this.section && parts[2] === this.key) {
            return parts[3];
        } else if (parts.length === 3 && parts[0] === "EXTSTATE" && parts[1] === this.section && parts[2] === this.key) {
            return undefined;
        }
        throw new Error(`Unexpected response format: ${line}`);
    }

    getResponseMarker(): string {
        return 'EXTSTATE'; // This command expects an EXTSTATE response
    }
}

// Command factory for convenience
export const Commands = {
    transport: () => new TransportCommand(),
    markers: () => new MarkersCommand(),
    goToStart: () => new GoToStartCommand(),
    goToMarker: (markerId: number) => new GoToMarkerCommand(markerId),
    newTab: () => new NewTabCommand(),
    closeAllTabs: () => new CloseAllTabsCommand(),
    nextTab: () => new NextTabCommand(),
    previousTab: () => new PreviousTabCommand(),
    play: () => new PlayCommand(),
    pause: () => new PauseCommand(),
    stop: () => new StopCommand(),
    record: () => new RecordCommand(),
} as const;
