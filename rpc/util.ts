export function indent(level: number, str: string): string {
    const indentation = '\t'.repeat(level);
    return str.split('\n').map(line => line.trim() === '' ? '' : indentation + line).join('\n');
}