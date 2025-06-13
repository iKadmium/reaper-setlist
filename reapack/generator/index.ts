/**
 * ReaPack Generator - Main module exports
 * A TypeScript tool for managing ReaPack index.xml files
 */

// Export main class
export { ReaPackGenerator } from './src/generator';

// Export types
export type {
    ReaPackAttributes,
    LinkElement,
    MetadataElement,
    SourceElement,
    VersionElement,
    PackageElement,
    CategoryElement,
    ReaPackIndex,
    ParsedIndex,
    AddReleaseOptions,
    MetadataOptions,
    SourceFileOptions
} from './src/types';

// Export utility functions
export { markdownToRtf, textToRtf, rtfToText } from './src/utils/rtf';
export { readIndex, writeIndex } from './src/utils/xml';
export {
    findOrCreateCategory,
    findOrCreatePackage,
    addVersion,
    cleanEmptyAttributes
} from './src/operations/index';