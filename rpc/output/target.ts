export abstract class Target {
	protected operations: OperationOptions[] = [];
	protected imports: string[] = [];

	protected abstract renderHeader(): string[];
	protected abstract renderImports(): string[];
	protected abstract renderOperations(): string[];

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
		lines.push(...this.renderOperations());

		return lines.join('\n');
	}
}

export interface OperationOptions {
	name: string;
	inputs: string[];
	outputs: string[];
}
