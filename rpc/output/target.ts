import type { ts, Type } from 'ts-morph';

export abstract class Target {
	protected operations: OperationOptions[] = [];
	protected imports: string[] = [];

	protected abstract renderHeader(): string[];
	protected abstract renderOperations(): string[];

	protected renderImports(): string[] {
		return this.imports;
	}

	protected renderClassDefinition(): string[] {
		return [];
	}

	protected renderClassEnd(): string[] {
		return [];
	}

	abstract getOutputPathParts(): string[];

	public addOperation(options: OperationOptions) {
		this.operations.push(options);
	}

	public render(): string {
		const lines: string[] = [];
		lines.push(...this.renderHeader());
		lines.push('');
		lines.push(...this.renderImports());
		lines.push('');
		lines.push(...this.renderClassDefinition());
		lines.push('');
		lines.push(...this.renderOperations());
		lines.push(...this.renderClassEnd());

		return lines.join('\n');
	}
}

export interface OperationOptions {
	name: string;
	inputs: Argument[];
	outputs: Argument[];
}

export interface Argument {
	name: string;
	type: Type<ts.Type>;
}
