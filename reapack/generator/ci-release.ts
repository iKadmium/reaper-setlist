#!/usr/bin/env bun

/**
 * CI Release Integration Script for ReaPack
 * 
 * This script automatically updates the ReaPack index when a new release is prepared.
 * It reads metadata from description files and detects package structure automatically.
 * 
 * Usage:
 *   bun ci-release.ts --version 1.2.0 --changelog "Added new features and bug fixes"
 *   bun ci-release.ts -v 1.2.0 -c "Bug fixes" --author "Your Name" --time "2025-06-13T10:00:00Z"
 */

import { Command } from 'commander';
import { promises as fs } from 'fs';
import * as path from 'path';
import { ReaPackGenerator } from './index';

interface ReleaseOptions {
    releaseVersion: string;
    changelog: string;
    author?: string;
    time?: string;
    indexPath?: string;
    repoPath?: string;
    packagePath?: string;
}

class CIReleaseManager {
    private generator: ReaPackGenerator;
    private repoPath: string;
    private packagePath: string;

    constructor(indexPath: string, repoPath: string, packagePath: string) {
        this.generator = new ReaPackGenerator(indexPath);
        this.repoPath = path.resolve(repoPath);
        this.packagePath = path.resolve(packagePath);
    }

    /**
     * Read markdown file content
     */
    private async readMarkdownFile(filePath: string): Promise<string> {
        try {
            const content = await fs.readFile(filePath, 'utf-8');
            return content.trim();
        } catch (error) {
            console.warn(`⚠️  Could not read ${filePath}: ${error instanceof Error ? error.message : String(error)}`);
            return '';
        }
    }

    /**
     * Detect package files in the directory
     */
    private async detectPackageFiles(packageDir: string): Promise<string[]> {
        const files: string[] = [];

        try {
            const entries = await fs.readdir(packageDir, { withFileTypes: true });

            for (const entry of entries) {
                if (entry.isFile()) {
                    const ext = path.extname(entry.name).toLowerCase();
                    // Include Lua scripts and web files
                    if (['.lua', '.html', '.htm', '.js', '.css'].includes(ext)) {
                        files.push(entry.name);
                    }
                } else if (entry.isDirectory()) {
                    // Recursively check files subdirectory
                    const filesDir = path.join(packageDir, entry.name);
                    const subFiles = await this.detectPackageFiles(filesDir);
                    files.push(...subFiles.map(f => path.join(entry.name, f)));
                }
            }
        } catch (error) {
            console.warn(`⚠️  Could not read directory ${packageDir}: ${error instanceof Error ? error.message : String(error)}`);
        }

        return files.sort();
    }

    /**
     * Generate GitHub raw URL for a file
     */
    private generateGitHubUrl(packageName: string, filePath: string, version: string): string {
        // Assuming GitHub repository structure
        const baseUrl = 'https://raw.githubusercontent.com/iKadmium/reaper-setlist/refs/tags';
        const repoPath = 'reapack/repo';
        return `${baseUrl}/v${version}/${repoPath}/${packageName}/files/${filePath}`;
    }

    /**
     * Determine package type based on file extensions
     */
    private determinePackageType(files: string[]): string {
        const hasLua = files.some(f => f.endsWith('.lua'));
        const hasHtml = files.some(f => f.endsWith('.html') || f.endsWith('.htm'));

        if (hasLua && hasHtml) {
            return 'webinterface'; // Script with web interface
        } else if (hasLua) {
            return 'script';
        } else if (hasHtml) {
            return 'webinterface';
        }

        return 'data'; // Default fallback
    }

    /**
     * Determine main sections for Lua scripts
     */
    private determineMainSections(files: string[]): string | undefined {
        const mainLuaFile = files.find(f => f.endsWith('.lua') && !f.includes('/'));
        if (mainLuaFile) {
            // For now, assume main section. This could be enhanced to parse the script
            return 'main';
        }
        return undefined;
    }

    /**
     * Get file type based on extension
     */
    private getFileType(file: string): string {
        const ext = path.extname(file).toLowerCase();
        switch (ext) {
            case '.lua':
                return 'script';
            case '.html':
            case '.htm':
                return 'webinterface';
            case '.js':
            case '.css':
                return 'data';
            default:
                return 'data';
        }
    }

    /**
     * Add a package release based on detected files
     */
    async addPackageRelease(options: ReleaseOptions): Promise<void> {
        const packageName = path.basename(this.packagePath);
        const descriptionPath = path.join(this.packagePath, 'description.md');
        const filesPath = path.join(this.packagePath, 'files');

        console.log(`🔍 Detecting package structure for: ${packageName}`);

        // Detect files
        const files: string[] = [];
        const scriptFiles = ['reaper-setlist.lua'];
        const webFiles = ['setlist.html'];
        const dataFiles = (await this.detectPackageFiles(path.join(filesPath, 'reaper-setlist'))).map(x => path.join('reaper-setlist', x));

        files.push(...scriptFiles, ...webFiles, ...dataFiles);
        //const files = await this.detectPackageFiles(filesPath);
        if (files.length === 0) {
            throw new Error(`No package files found in ${filesPath}`);
        }

        console.log(`📁 Found ${files.length} package files:`);
        files.forEach(file => console.log(`   - ${file}`));

        // Read description
        const description = await this.readMarkdownFile(descriptionPath);

        // Determine package properties
        const packageType = this.determinePackageType(files);
        const mainSections = this.determineMainSections(files);

        console.log(`📦 Package type: ${packageType}`);
        if (mainSections) {
            console.log(`🎯 Main sections: ${mainSections}`);
        }

        // Create sources for each file
        const scriptSources = scriptFiles.map(file => ({
            url: this.generateGitHubUrl(packageName, file, options.releaseVersion),
            file: file,
            platform: 'all' as const,
            type: 'script',
            main: mainSections
        }));

        const webSources = webFiles.map(file => ({
            url: this.generateGitHubUrl(packageName, file, options.releaseVersion),
            file: file,
            platform: 'all' as const,
            type: 'webinterface',
            main: mainSections
        }));

        const dataSources = dataFiles.map(file => ({
            url: this.generateGitHubUrl(packageName, file, options.releaseVersion),
            file: file,
            platform: 'all' as const,
            main: mainSections
        }));

        // Prepare metadata if description exists
        const metadata = description ? {
            description: description,
            links: [
                {
                    rel: 'website',
                    href: 'https://github.com/iKadmium/reaper-setlist',
                    text: 'GitHub Repository'
                }
            ]
        } : undefined;

        // Add the release
        await this.generator.addRelease({
            category: 'Scripts', // Could be made configurable
            package: packageName,
            type: packageType,
            version: options.releaseVersion,
            changelog: options.changelog,
            sources: [...scriptSources, ...webSources, ...dataSources],
            description: `${packageName} - REAPER package`,
            metadata: metadata,
            author: options.author,
            time: options.time
        });

        console.log(`✅ Added ${packageName} v${options.releaseVersion} to ReaPack index`);
    }

    /**
     * List packages in the current index
     */
    async listPackages(): Promise<void> {
        await this.generator.listPackages();
    }
}

// CLI setup
const program = new Command();

program
    .name('ci-release')
    .description('CI Release Integration for ReaPack')
    .version('1.0.0');

program
    .command('release')
    .description('Add a new release to the ReaPack index')
    .requiredOption('-v, --release-version <version>', 'Release version (e.g., "1.2.0")')
    .requiredOption('-c, --changelog <changelog>', 'Release changelog/notes')
    .option('-a, --author <author>', 'Release author name')
    .option('-t, --time <time>', 'Release time (ISO 8601 format)', new Date().toISOString())
    .option('-i, --index <path>', 'Path to index.xml file', '../repo/index.xml')
    .option('-r, --repo <path>', 'Path to repository root', '../repo')
    .option('-p, --package <path>', 'Path to package directory', '../repo/reaper-setlist')
    .action(async (options) => {
        try {
            const indexPath = path.resolve(options.index);
            const repoPath = path.resolve(options.repo);
            const packagePath = path.resolve(options.package);

            console.log('🚀 Starting CI release process...');
            console.log('================================');
            console.log(`   Version: ${options.releaseVersion}`);
            console.log(`   Author: ${options.author || 'Not specified'}`);
            console.log(`   Time: ${options.time}`);
            console.log(`   Index: ${indexPath}`);
            console.log(`   Repo: ${repoPath}`);
            console.log(`   Package: ${packagePath}`);
            console.log('');

            const manager = new CIReleaseManager(indexPath, repoPath, packagePath);
            await manager.addPackageRelease(options);

            console.log('');
            console.log('📋 Updated repository contents:');
            await manager.listPackages();

            console.log('');
            console.log('✅ CI release process completed successfully!');

        } catch (error) {
            console.error('❌ CI release failed:', error instanceof Error ? error.message : String(error));
            process.exit(1);
        }
    });

program
    .command('list')
    .description('List all packages in the current index')
    .option('-i, --index <path>', 'Path to index.xml file', '../repo/index.xml')
    .action(async (options) => {
        try {
            const indexPath = path.resolve(options.index);
            const generator = new ReaPackGenerator(indexPath);
            await generator.listPackages();
        } catch (error) {
            console.error('❌ Failed to list packages:', error instanceof Error ? error.message : String(error));
            process.exit(1);
        }
    });

// Error handling
program.configureHelp({
    sortSubcommands: true,
});

program.on('command:*', () => {
    console.error('Invalid command: %s\nSee --help for a list of available commands.', program.args.join(' '));
    process.exit(1);
});

// Parse command line arguments
try {
    await program.parseAsync(process.argv);
} catch (error) {
    console.error('❌ Error:', error instanceof Error ? error.message : String(error));
    process.exit(1);
}