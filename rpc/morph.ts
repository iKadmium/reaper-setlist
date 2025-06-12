import * as fs from 'node:fs';
import * as path from 'node:path';
import { Project } from 'ts-morph';
import { LuaTarget } from './output/lua-target';
import type { Argument, OperationOptions } from './output/target';
import { TypeScriptTarget } from './output/typescript-target';

const project = new Project({
	tsConfigFilePath: 'tsconfig.json' // Point to your tsconfig for type resolution
});

const sourceFile = project.getSourceFileOrThrow('./input/script-operations.ts');
const scriptOperationsInterface = sourceFile.getInterfaceOrThrow('ScriptOperations');

const targets = [new LuaTarget(), new TypeScriptTarget()];

for (const prop of scriptOperationsInterface.getProperties()) {
	const operationName = prop.getName();
	const propType = prop.getType();

	if (propType.getCallSignatures().length > 0) {
		const signature = propType.getCallSignatures()[0];
		if (!signature) continue;

		const parameters = signature.getParameters();
		const returnType = signature.getReturnType();

		// Get parameters from state
		const inputs: Argument[] = [];
		for (const param of parameters) {
			const paramName = param.getName();
			const paramType = param.getTypeAtLocation(sourceFile);
			inputs.push({ name: paramName, type: paramType });
		}

		const outputs: Argument[] = [];
		if (returnType.isVoid() || returnType.getText(sourceFile) === 'Promise<void>') {
			// No return value
		} else {
			// Check if it's a Promise type and extract the awaited type
			for (const prop of returnType.getProperties()) {
				const outputName = prop.getName();
				const outputType = prop.getTypeAtLocation(sourceFile);
				outputs.push({ name: outputName, type: outputType });
			}
		}

		const typeArgs = signature.getTypeParameters();

		for (const target of targets) {
			target.addOperation({
				name: operationName,
				inputs,
				outputs,
				typeArgs
			});
		}
	}
}

for (const target of targets) {
	const outputPath = path.join(...target.getOutputPathParts());

	const content = target.render();

	fs.writeFileSync(outputPath, content, 'utf8');
	console.log(`Generated ${outputPath}`);
}
