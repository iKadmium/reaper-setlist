#!/usr/bin/env bun

/**
 * ReaPack Generator CLI - Command line interface for managing ReaPack index.xml files
 */

import { Command } from 'commander';
import * as path from 'node:path';
import { ReaPackGenerator } from './src/generator';
import * as fs from 'node:fs/promises';

// CLI setup
const program = new Command();

program
    .name('reapack-generator')
    .description('ReaPack index.xml generator and manager')
    .version('1.0.0')
    .option('-i, --index <path>', 'Path to index.xml file', '../repo/index.xml');

program
    .command('init')
    .description('Initialize a new empty index')
    .option('-n, --name <name>', 'Repository name')
    .action(async (options) => {
        const indexPath = path.resolve(program.opts().index);
        const generator = new ReaPackGenerator(indexPath);
        await generator.init(options.name);
    });

program
    .command('add')
    .description('Add a new release to the index')
    .requiredOption('-c, --category <category>', 'Package category (e.g., "Scripts", "Effects")')
    .requiredOption('-p, --package <package>', 'Package name (e.g., "My Script.lua")')
    .requiredOption('-t, --type <type>', 'Package type (script, effect, extension, data, theme, langpack, webinterface, projecttpl, tracktpl, midinotenames, autoitem)')
    .requiredOption('-v, --version <version>', 'Version number (e.g., "1.0.0")')
    .requiredOption('-u, --url <url>', 'Source download URL')
    .option('-l, --changelog <changelog>', 'Release changelog/notes', '')
    .option('-f, --file <file>', 'Source file path (if different from package name)')
    .option('--platform <platform>', 'Target platform (all, windows, darwin, linux)', 'all')
    .option('--main <sections>', 'Main sections (e.g., "main midi_editor")')
    .option('-d, --description <description>', 'Package description')
    .action(async (options) => {
        const indexPath = path.resolve(program.opts().index);
        const generator = new ReaPackGenerator(indexPath);

        const sources = [{
            url: options.url,
            file: options.file,
            platform: options.platform,
            main: options.main
        }];

        await generator.addRelease({
            category: options.category,
            package: options.package,
            type: options.type,
            version: options.version,
            changelog: options.changelog,
            sources,
            description: options.description
        });
    });

program
    .command('metadata')
    .description('Set repository metadata')
    .option('-n, --name <name>', 'Repository name')
    .option('-d, --description <description>', 'Repository description')
    .option('-m, --markdown <file>', 'Path to repository description in Markdown format')
    .option('-w, --website <url>', 'Website URL')
    .option('--donation <url>', 'Donation URL')
    .action(async (options) => {
        const indexPath = path.resolve(program.opts().index);
        const generator = new ReaPackGenerator(indexPath);

        const description = options.markdown ? await fs.readFile(options.markdown, 'utf-8') : options.description;

        await generator.setMetadata({
            name: options.name,
            description: description,
            website: options.website,
            donation: options.donation
        });

        console.log('✅ Updated repository metadata');
    });

program
    .command('list')
    .description('List all packages in the index')
    .action(async () => {
        const indexPath = path.resolve(program.opts().index);
        const generator = new ReaPackGenerator(indexPath);
        await generator.listPackages();
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
