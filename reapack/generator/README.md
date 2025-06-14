# ReaPack Generator

A TypeScript tool for managing ReaPack index.xml files. This tool allows you to programmatically create and manage ReaPack repositories for REAPER scripts, effects, and other packages.

## Features

- ✅ Create and initialize new ReaPack repositories
- ✅ Add releases with automatic versioning
- ✅ Set repository metadata (name, description, website, donation links)
- ✅ List all packages and versions
- ✅ RTF formatting for changelogs and descriptions
- ✅ Platform-specific package support
- ✅ TypeScript with full type safety

## Installation

```bash
bun install
```

## Usage

### Command Line Interface

The tool provides a CLI for common operations:

```bash
# Initialize a new repository
bun run cli.ts init --name "My ReaPack Repository"

# Add a new release
bun run cli.ts add \
  --category "Scripts" \
  --package "My Script.lua" \
  --type "script" \
  --version "1.0.0" \
  --url "https://github.com/user/repo/raw/main/scripts/My%20Script.lua" \
  --changelog "Initial release with basic functionality"

# Set repository metadata
bun run cli.ts metadata \
  --name "My Repository" \
  --description "Collection of REAPER scripts and tools" \
  --website "https://github.com/user/repo" \
  --donation "https://paypal.me/user"

# List all packages
bun run cli.ts list
```

### Programmatic API

You can also use the ReaPackGenerator class directly in your TypeScript code:

```typescript
import { ReaPackGenerator } from "./index.js";

const generator = new ReaPackGenerator("./path/to/index.xml");

// Initialize a new repository
await generator.init("My Repository");

// Add a release
await generator.addRelease({
  category: "Scripts",
  package: "My Script.lua",
  type: "script",
  version: "1.0.0",
  changelog: "Initial release",
  sourceUrl: "https://example.com/script.lua",
  description: "A useful REAPER script",
});

// Set metadata
await generator.setMetadata({
  name: "My Repository",
  description: "Collection of REAPER tools",
  website: "https://github.com/user/repo",
});
```

## Package Types

ReaPack supports the following package types:

- `script` - Lua/Python/EEL scripts
- `effect` - VST/AU/JS effects
- `extension` - REAPER extensions (.dll/.dylib/.so)
- `data` - Data files
- `theme` - REAPER themes
- `langpack` - Language packs
- `webinterface` - Web interface files
- `projecttpl` - Project templates
- `tracktpl` - Track templates
- `midinotenames` - MIDI note name maps
- `autoitem` - Auto item files

## Development

### Build

```bash
bun run build
```

### Development Mode

```bash
bun run dev
```

### Testing

```bash
bun test
```

## Project Structure

```
src/
├── generator.ts          # Main ReaPackGenerator class
├── types.ts             # TypeScript type definitions
├── operations/
│   └── index.ts         # Index manipulation operations
└── utils/
    ├── rtf.ts           # RTF formatting utilities
    └── xml.ts           # XML read/write operations
```

## License

MIT License - see LICENSE file for details.
