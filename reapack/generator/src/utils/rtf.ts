/**
 * RTF (Rich Text Format) utility functions for ReaPack compatibility
 */

import markdownit from "markdown-it";
import rtf from "html-to-rtf";

/**
 * Convert Markdown to RTF format for ReaPack compatibility
 * ReaPack expects changelog and description content in RTF format wrapped in CDATA
 */
export async function markdownToRtf(markdown: string): Promise<string> {
  // Parse markdown to HTML first
  const md = markdownit();
  const doc = md.render(markdown);

  // Convert HTML to RTF
  const rtfDoc = await rtf.convertHtmlToRtf(doc);

  // Return RTF content wrapped in CDATA for xml2js compatibility
  // xml2js will handle the CDATA wrapper properly when we use the _cdata property
  return rtfDoc;
}
