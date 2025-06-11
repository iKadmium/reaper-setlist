# Configuration Store

The configuration store caches `scriptActionId` and `folderPath` values to make them available throughout the application without repeated API calls.

## Usage

### Basic Import

```typescript
import { configuration } from '$lib';
```

### Accessing Cached Values

```javascript
// In a Svelte component
<script>
  import { configuration } from '$lib';

  // Access individual values reactively
  const scriptActionId = $derived(configuration.scriptActionId);
  const folderPath = $derived(configuration.folderPath);
  const isSetupComplete = $derived(configuration.isSetupComplete);

  // Access the full configuration object
  const config = $derived(configuration.data);
</script>

{#if config.setupComplete}
  <p>Script Action ID: {config.scriptActionId}</p>
  <p>Folder Path: {config.folderPath}</p>
{:else}
  <p>Setup not complete</p>
{/if}
```

### Updating Configuration

```javascript
// Update script action ID
await configuration.updateScriptActionId('new-action-id');

// Update folder path
await configuration.updateFolderPath('/path/to/folder');

// These methods automatically update the setupComplete status
```

### Initialization

The store automatically initializes when first accessed in `+layout.ts`, but you can manually initialize it:

```javascript
// Initialize with optional fetch function
await configuration.initialize(fetch);
```

### Reset

```javascript
// Reset all values to undefined/false
configuration.reset();
```

## Store Properties

- `data`: Complete configuration object with `scriptActionId`, `folderPath`, and `setupComplete`
- `scriptActionId`: The cached script action ID value
- `folderPath`: The cached folder path value
- `isSetupComplete`: Boolean indicating if both values are set

## Methods

- `initialize(fetch?)`: Initialize the store by fetching current values
- `updateScriptActionId(id, fetch?)`: Update script action ID and save to API
- `updateFolderPath(path, fetch?)`: Update folder path and save to API
- `reset()`: Reset all values and initialization state

## Integration with Layout

The store is initialized in `+layout.ts` and the cached values are used to determine if setup is complete, avoiding redundant API calls on every navigation.
