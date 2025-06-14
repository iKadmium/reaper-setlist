/**
 * ReaPack Generator - Main class for managing ReaPack index.xml files
 */

import type { ParsedIndex, AddReleaseOptions, MetadataOptions } from './types';
import { readIndex, writeIndex } from './utils/xml';
import { markdownToRtf } from './utils/rtf';
import { findOrCreateCategory, findOrCreatePackage, addVersion } from './operations/index';

export class ReaPackGenerator {
    private indexPath: string;

    constructor(indexPath: string) {
        this.indexPath = indexPath;
    }

    /**
     * Set repository metadata
     */
    async setMetadata(options: MetadataOptions): Promise<void> {
        const indexData = await readIndex(this.indexPath);

        if (options.name) {
            indexData.index.$.name = options.name;
        }

        if (options.description || options.website || options.donation) {
            if (!indexData.index.metadata) {
                indexData.index.metadata = [{}];
            }

            // Ensure we have a metadata object
            let metadata = indexData.index.metadata[0];
            if (!metadata) {
                metadata = {};
                indexData.index.metadata[0] = metadata;
            }

            if (options.description) {
                metadata.description = [await markdownToRtf(options.description)];
            }

            if (options.website || options.donation) {
                if (!metadata.link) {
                    metadata.link = [];
                }

                if (options.website) {
                    metadata.link.push({
                        $: { rel: 'website', href: options.website },
                        _: options.website
                    });
                }

                if (options.donation) {
                    metadata.link.push({
                        $: { rel: 'donation', href: options.donation },
                        _: 'Donate!'
                    });
                }
            }
        }

        await writeIndex(this.indexPath, indexData);
    }

    /**
     * Add a new release to the index
     */
    async addRelease(options: AddReleaseOptions): Promise<void> {
        const indexData = await readIndex(this.indexPath);

        const category = findOrCreateCategory(indexData, options.category);
        const pkg = findOrCreatePackage(category, options.package, options.type);

        // Set package description if provided
        if (options.description) {
            pkg.$.desc = options.description;
        }

        // Add package metadata if provided
        if (options.metadata) {
            if (!pkg.metadata) {
                pkg.metadata = [{}];
            }

            let metadata = pkg.metadata[0];
            if (!metadata) {
                metadata = {};
                pkg.metadata[0] = metadata;
            }

            if (options.metadata.description) {
                metadata.description = [await markdownToRtf(options.metadata.description)];
            }

            if (options.metadata.links) {
                if (!metadata.link) {
                    metadata.link = [];
                }

                for (const link of options.metadata.links) {
                    metadata.link.push({
                        $: { rel: link.rel, href: link.href },
                        _: link.text || link.href || ''
                    });
                }
            }
        }

        await addVersion(
            pkg,
            options.version,
            options.changelog,
            options.sources,
            options.author,
            options.time
        );

        await writeIndex(this.indexPath, indexData);
        console.log(`✅ Added ${options.package} v${options.version} to ${options.category}`);
    }

    /**
     * List all packages in the index
     */
    async listPackages(): Promise<void> {
        const indexData = await readIndex(this.indexPath);

        if (!indexData.index.category || indexData.index.category.length === 0) {
            console.log('📦 No packages found in index');
            return;
        }

        console.log('📦 ReaPack Index Contents:');
        console.log('========================');

        if (indexData.index.$.name) {
            console.log(`Repository: ${indexData.index.$.name}`);
            console.log('');
        }

        for (const category of indexData.index.category) {
            console.log(`📁 ${category.$.name}`);

            if (category.reapack) {
                for (const pkg of category.reapack) {
                    console.log(`  📄 ${pkg.$.name} (${pkg.$.type})`);

                    if (pkg.version) {
                        for (const version of pkg.version) {
                            console.log(`    🏷️  v${version.$.name}`);
                        }
                    }
                }
            }
            console.log('');
        }
    }

    /**
     * Initialize a new empty index
     */
    async init(repoName?: string): Promise<void> {
        const indexData: ParsedIndex = {
            index: {
                $: {
                    version: '1',
                    name: repoName
                }
            }
        };

        await writeIndex(this.indexPath, indexData);
        console.log(`✅ Initialized new ReaPack index${repoName ? ` for "${repoName}"` : ''}`);
    }

    /**
     * Get the current index data
     */
    async getIndex(): Promise<ParsedIndex> {
        return readIndex(this.indexPath);
    }

    /**
     * Get index file path
     */
    getIndexPath(): string {
        return this.indexPath;
    }
}
