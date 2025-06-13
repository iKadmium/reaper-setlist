/**
 * ReaPack index.xml type definitions
 */

export interface ReaPackAttributes {
    version: string;
    name?: string;
    commit?: string;
}

export interface LinkElement {
    $: {
        rel: string;
        href?: string;
    };
    _?: string;
}

export interface MetadataElement {
    description?: Array<string>;
    link?: Array<LinkElement>;
}

export interface SourceElement {
    $: {
        platform?: string;
        type?: string;
        file?: string;
        main?: string;
    };
    _: string;
}

export interface VersionElement {
    $: {
        name: string;
        author?: string;
        time?: string;
    };
    changelog?: Array<string>;
    source?: Array<SourceElement>;
}

export interface PackageElement {
    $: {
        name: string;
        type: string;
        desc?: string;
    };
    metadata?: Array<MetadataElement>;
    version?: Array<VersionElement>;
}

export interface CategoryElement {
    $: {
        name: string;
    };
    reapack?: Array<PackageElement>;
}

export interface ReaPackIndex {
    $: ReaPackAttributes;
    metadata?: Array<MetadataElement>;
    category?: Array<CategoryElement>;
}

export interface ParsedIndex {
    index: ReaPackIndex;
}

export interface SourceFileOptions {
    url: string;
    file?: string;
    type?: string;
    main?: string;
    platform?: string;
}

export interface AddReleaseOptions {
    category: string;
    package: string;
    type: string;
    version: string;
    changelog: string;
    sources: SourceFileOptions[]; // Changed to support multiple source files
    description?: string;
    author?: string;
    time?: string;
    metadata?: {
        description?: string;
        links?: Array<{
            rel: string;
            href?: string;
            text?: string;
        }>;
    };
}

export interface MetadataOptions {
    name?: string;
    description?: string;
    website?: string;
    donation?: string;
    links?: Array<{
        rel: string;
        href?: string;
        text?: string;
    }>;
}
