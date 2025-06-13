/**
 * XML operations for ReaPack index management
 */

import { promises as fs } from 'fs';
import * as path from 'path';
import { parseString, Builder } from 'xml2js';
import type { ParsedIndex } from '../types';

/**
 * Read and parse existing index.xml file
 */
export async function readIndex(indexPath: string): Promise<ParsedIndex> {
    try {
        const content = await fs.readFile(indexPath, 'utf-8');

        if (content.trim() === '') {
            // Create a new empty index structure
            return {
                index: {
                    $: {
                        version: '1'
                    }
                }
            };
        }

        return new Promise((resolve, reject) => {
            parseString(content, { trim: true, normalize: true }, (err, result) => {
                if (err) {
                    reject(err);
                } else {
                    resolve(result as ParsedIndex);
                }
            });
        });
    } catch (error) {
        if ((error as NodeJS.ErrnoException).code === 'ENOENT') {
            // File doesn't exist, create new structure
            return {
                index: {
                    $: {
                        version: '1'
                    }
                }
            };
        }
        throw error;
    }
}

/**
 * Write the index back to XML file
 */
export async function writeIndex(indexPath: string, indexData: ParsedIndex): Promise<void> {
    const builder = new Builder({
        xmldec: { version: '1.0', encoding: 'utf-8' },
        renderOpts: { pretty: true, indent: '  ', newline: '\n' }
    });

    const xml = builder.buildObject(indexData);

    // Ensure directory exists
    await fs.mkdir(path.dirname(indexPath), { recursive: true });

    await fs.writeFile(indexPath, xml, 'utf-8');
}
