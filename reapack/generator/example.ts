#!/usr/bin/env bun

/**
 * Example usage of the ReaPack Generator
 * This script demonstrates how to programmatically manage a ReaPack repository
 */

import { ReaPackGenerator } from './index';
import * as path from 'path';

async function main() {
    console.log('🚀 ReaPack Generator Example');
    console.log('============================\n');

    // Create a generator instance pointing to our repo index
    const indexPath = path.resolve('../repo/index.xml');
    const generator = new ReaPackGenerator(indexPath);

    try {
        // 1. Initialize repository (if needed)
        console.log('📝 Setting up repository metadata...');
        await generator.setMetadata({
            name: 'REAPER Setlist',
            description: 'A comprehensive setlist management tool for REAPER, featuring an intuitive web interface for organizing and controlling your live performances.',
            website: 'https://github.com/your-username/reaper-setlist',
            donation: 'https://github.com/sponsors/your-username'
        });

        // 2. Add the main Lua script
        console.log('📦 Adding Lua script package...');
        await generator.addRelease({
            category: 'Scripts',
            package: 'reaper-setlist.lua',
            type: 'script',
            version: '1.0.0',
            changelog: `## Initial release of REAPER Setlist

Features:
• Web-based setlist management interface
• Live performance mode with navigation controls
• Song and set organization
• Real-time transport integration
• Backup and restore functionality`,
            sources: [{
                url: 'https://github.com/your-username/reaper-setlist/raw/main/reapack/repo/lua/reaper-setlist.lua',
                main: 'main'
            }],
            description: 'Main REAPER Setlist script - provides web interface and setlist management functionality',
            metadata: {
                description: `# Song switcher

The purpose of this script is to quickly switch between songs in a single project during live shows. It is a replacement for the slow SWS Snapshots (visibility + mute).

## Usage

Each song must be in a top-level folder track named "#. Song Name" ("#" being any number).

After selecting a song, Song switcher mutes and hides all songs in the project except for the current one. Other tracks/folders that are not part of a song's top-level folder are left untouched.
Song switcher can also optionally stop playback and/or seek to the first item in the song when switching.

This script works best with REAPER settings **"Do not process muted tracks"** and **"Track mute fade"** enabled.`,
                links: [
                    { rel: 'website', href: 'https://github.com/your-username/reaper-setlist', text: 'GitHub Repository' },
                    { rel: 'screenshot', href: 'https://i.imgur.com/example.png', text: 'Interface Screenshot' }
                ]
            }
        });

        // 3. Add the HTML interface
        console.log('🌐 Adding web interface...');
        await generator.addRelease({
            category: 'Web Interfaces',
            package: 'setlist.html',
            type: 'webinterface',
            version: '1.0.0',
            changelog: 'Web interface for setlist management and live performance control',
            sources: [{
                url: 'https://github.com/your-username/reaper-setlist/raw/main/reapack/repo/web/setlist.html',
                type: 'webinterface'
            }],
            description: 'HTML interface for managing setlists and controlling live performances'
        });

        // 4. List all packages to verify
        console.log('\n📋 Current repository contents:');
        await generator.listPackages();

        console.log('\n✅ Repository setup complete!');
        console.log(`📄 Index file: ${indexPath}`);

    } catch (error) {
        console.error('❌ Error:', error instanceof Error ? error.message : String(error));
        process.exit(1);
    }
}

// Run the example
await main().catch(console.error);
