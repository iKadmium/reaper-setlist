/**
 * Index manipulation operations for ReaPack packages
 */

import type { ParsedIndex, CategoryElement, PackageElement, VersionElement, SourceElement, SourceFileOptions } from '../types';
import { markdownToRtf } from '../utils/rtf';

/**
 * Find or create a category in the index
 */
export function findOrCreateCategory(indexData: ParsedIndex, categoryName: string): CategoryElement {
    if (!indexData.index.category) {
        indexData.index.category = [];
    }

    let category = indexData.index.category.find(cat => cat.$.name === categoryName);

    if (!category) {
        category = {
            $: { name: categoryName },
            reapack: []
        };
        indexData.index.category.push(category);

        // Sort categories alphabetically
        indexData.index.category.sort((a, b) => a.$.name.localeCompare(b.$.name));
    }

    return category;
}

/**
 * Find or create a package in a category
 */
export function findOrCreatePackage(category: CategoryElement, packageName: string, packageType: string): PackageElement {
    if (!category.reapack) {
        category.reapack = [];
    }

    let pkg = category.reapack.find(p => p.$.name === packageName);

    if (!pkg) {
        pkg = {
            $: {
                name: packageName,
                type: packageType
            },
            version: []
        };
        category.reapack.push(pkg);

        // Sort packages alphabetically
        category.reapack.sort((a, b) => a.$.name.localeCompare(b.$.name));
    }

    return pkg;
}

/**
 * Add a new version to a package with support for multiple source files
 */
export async function addVersion(
    pkg: PackageElement,
    versionName: string,
    changelog: string,
    sources: SourceFileOptions[],
    author?: string,
    time?: string
): Promise<void> {
    if (!pkg.version) {
        pkg.version = [];
    }

    // Check if version already exists
    const existingVersion = pkg.version.find(v => v.$.name === versionName);
    if (existingVersion) {
        throw new Error(`Version ${versionName} already exists for package ${pkg.$.name}`);
    }

    // Create source elements
    const sourceElements: SourceElement[] = sources.map(source => {
        const sourceElement: SourceElement = {
            $: {
                platform: source.platform && source.platform !== 'all' ? source.platform : undefined,
                type: source.type,
                file: source.file,
                main: source.main
            },
            _: source.url
        };

        // Clean up undefined attributes
        Object.keys(sourceElement.$).forEach(key => {
            if (sourceElement.$[key as keyof typeof sourceElement.$] === undefined) {
                delete sourceElement.$[key as keyof typeof sourceElement.$];
            }
        });

        return sourceElement;
    });

    const newVersion: VersionElement = {
        $: {
            name: versionName,
            author,
            time
        },
        source: sourceElements
    };

    // Clean up undefined attributes on version
    Object.keys(newVersion.$).forEach(key => {
        if (newVersion.$[key as keyof typeof newVersion.$] === undefined) {
            delete newVersion.$[key as keyof typeof newVersion.$];
        }
    });

    // Add changelog if provided
    if (changelog.trim()) {
        newVersion.changelog = [await markdownToRtf(changelog)];
    }

    pkg.version.push(newVersion);
}

/**
 * Clean empty attributes from objects
 */
export function cleanEmptyAttributes(obj: any): void {
    if (typeof obj !== 'object' || obj === null) return;

    for (const key in obj) {
        if (obj[key] === undefined || obj[key] === null || obj[key] === '') {
            delete obj[key];
        } else if (typeof obj[key] === 'object') {
            cleanEmptyAttributes(obj[key]);
        }
    }
}
