import type { ts, Type } from 'ts-morph';

export abstract class Target {
	protected operations: OperationOptions[] = [];
	protected imports: string[] = [];
	protected types: Record<string, Type<ts.Type>> = {};

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

	protected renderTypeDefinitions(): string[] {
		return [];
	}

	abstract getOutputPathParts(): string[];

	public addOperation(options: OperationOptions) {
		this.operations.push(options);
		for (const output of options.outputs) {
			if (!this.types[output.type.getText()]) {
				this.types[output.type.getText()] = output.type;
			}
		}
	}

	public render(): string {
		const lines: string[] = [];
		const header = this.renderHeader();
		if (header.length > 0) {
			lines.push(...header);
			lines.push('');
		}
		const imports = this.renderImports();
		if (imports.length > 0) {
			lines.push(...imports);
			lines.push('');
		}
		const typeDefinitions = this.renderTypeDefinitions();
		if (typeDefinitions.length > 0) {
			lines.push(...typeDefinitions);
			lines.push('');
		}
		const classDefinition = this.renderClassDefinition();
		if (classDefinition.length > 0) {
			lines.push(...classDefinition);
			lines.push('');
		}
		const operations = this.renderOperations();
		if (operations.length > 0) {
			lines.push(...operations);
		}
		const classEnd = this.renderClassEnd();
		if (classEnd.length > 0) {
			lines.push(...classEnd);
		}

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
