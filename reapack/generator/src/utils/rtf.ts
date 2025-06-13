/**
 * RTF (Rich Text Format) utility functions for ReaPack compatibility
 */

import { richTextFromMarkdown } from '@contentful/rich-text-from-markdown';
import { marked } from 'marked';

/**
 * Convert Markdown to RTF format for ReaPack compatibility
 * ReaPack expects changelog and description content in RTF format
 */
export async function markdownToRtf(markdown: string): Promise<string> {
    // Parse markdown to HTML first
    const html = await marked(markdown);

    // Convert HTML to plain text with basic formatting
    let text = html
        // Convert headers
        .replace(/<h([1-6])[^>]*>(.*?)<\/h[1-6]>/gi, (_, level, content) => {
            const size = level === '1' ? '36' : level === '2' ? '32' : '28';
            return `{\\b \\fs${size} ${content.replace(/<[^>]*>/g, '')}\\par}\n`;
        })
        // Convert bold
        .replace(/<(?:b|strong)[^>]*>(.*?)<\/(?:b|strong)>/gi, '{\\b $1}')
        // Convert italic
        .replace(/<(?:i|em)[^>]*>(.*?)<\/(?:i|em)>/gi, '{\\i $1}')
        // Convert code spans
        .replace(/<code[^>]*>(.*?)<\/code>/gi, '{\\f1 $1}')
        // Convert line breaks
        .replace(/<br\s*\/?>/gi, '\\line ')
        // Convert paragraphs
        .replace(/<p[^>]*>(.*?)<\/p>/gi, '{\\pard \\ql \\f0 \\sa180 \\li0 \\fi0 $1\\par}\n')
        // Convert unordered lists
        .replace(/<ul[^>]*>(.*?)<\/ul>/gis, (_, content) => {
            return content.replace(/<li[^>]*>(.*?)<\/li>/gi, '{\\pard \\ql \\f0 \\sa0 \\li360 \\fi-360 \\bullet \\tx360\\tab $1\\par}\n');
        })
        // Convert ordered lists
        .replace(/<ol[^>]*>(.*?)<\/ol>/gis, (_, content) => {
            let counter = 0;
            return content.replace(/<li[^>]*>(.*?)<\/li>/gi, () => {
                counter++;
                return `{\\pard \\ql \\f0 \\sa0 \\li360 \\fi-360 ${counter}. \\tx360\\tab $1\\par}\n`;
            });
        })
        // Remove any remaining HTML tags
        .replace(/<[^>]*>/g, '')
        // Decode HTML entities
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>')
        .replace(/&amp;/g, '&')
        .replace(/&quot;/g, '"')
        .replace(/&#39;/g, "'")
        // Clean up extra whitespace
        .replace(/\n\s*\n/g, '\n')
        .trim();

    // Escape RTF special characters
    const escaped = text
        .replace(/\\/g, '\\\\')
        .replace(/\{/g, '\\{')
        .replace(/\}/g, '\\}');

    // Wrap in RTF structure
    return `{\\rtf1\\ansi\\deff0{\\fonttbl{\\f0 \\fswiss Helvetica;}{\\f1 \\fmodern Courier;}}
{\\colortbl;\\red255\\green0\\blue0;\\red0\\green0\\blue255;}
\\widowctrl\\hyphauto

${escaped}
}`;
}

/**
 * Legacy function for plain text to RTF conversion
 * @deprecated Use markdownToRtf instead
 */
export function textToRtf(text: string): string {
    // Basic RTF conversion - escapes special characters and wraps in RTF structure
    const escaped = text
        .replace(/\\/g, '\\\\')
        .replace(/\{/g, '\\{')
        .replace(/\}/g, '\\}')
        .replace(/\n/g, '\\par\n');

    return `{\\rtf1\\ansi\\deff0{\\fonttbl{\\f0 \\fswiss Helvetica;}{\\f1 \\fmodern Courier;}}
{\\colortbl;\\red255\\green0\\blue0;\\red0\\green0\\blue255;}
\\widowctrl\\hyphauto

{\\pard \\ql \\f0 \\sa180 \\li0 \\fi0 ${escaped}\\par}
}`;
}

/**
 * Convert RTF text back to plain text (for display purposes)
 * This is a basic implementation that strips RTF formatting
 */
export function rtfToText(rtf: string): string {
    // Remove RTF header and control codes
    return rtf
        .replace(/^{\\rtf1[^}]*}/, '')
        .replace(/\\par\n/g, '\n')
        .replace(/\\{/g, '{')
        .replace(/\\}/g, '}')
        .replace(/\\\\/g, '\\')
        .replace(/{[^}]*}/g, '')
        .replace(/\\[a-z]+[0-9]*\s?/gi, '')
        .trim();
}
