import { ts, type Node, type Type } from "ts-morph";

export function indent(level: number, str: string): string {
    const indentation = '\t'.repeat(level);
    return str.split('\n').map(line => line.trim() === '' ? '' : indentation + line).join('\n');
}

export function getMembers(type: Type<ts.Type>): Record<string, Node<ts.Node>> {
    const members: Record<string, Node<ts.Node>> = {};
    for (const member of type.getProperties()) {
        const name = member.getName();
        if (!members[name]) {
            const declarations = member.getDeclarations();
            const propertySignature = declarations.find(decl => decl.getKind() === ts.SyntaxKind.PropertySignature);
            if (propertySignature) {
                members[name] = propertySignature;
            }

        }
    }
    return members;
}