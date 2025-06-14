/**
 * XML operations for ReaPack index management
 */

import { promises as fs } from "fs";
import * as path from "path";
import { parseString, Builder } from "xml2js";
import type { ParsedIndex } from "../types";

/**
 * Read and parse existing index.xml file
 */
export async function readIndex(indexPath: string): Promise<ParsedIndex> {
  try {
    const content = await fs.readFile(indexPath, "utf-8");

    if (content.trim() === "") {
      // Create a new empty index structure
      return {
        index: {
          $: {
            version: "1",
          },
        },
      };
    }

    return new Promise((resolve, reject) => {
      parseString(content, { trim: true, normalize: true }, (err, result) => {
        if (err) {
          reject(err);
        } else {
          resolve(result as ParsedIndex);
        }
      });
    });
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") {
      // File doesn't exist, create new structure
      return {
        index: {
          $: {
            version: "1",
          },
        },
      };
    }
    throw error;
  }
}

/**
 * Write the index back to XML file
 */
export async function writeIndex(
  indexPath: string,
  indexData: ParsedIndex
): Promise<void> {
  const builder = new Builder({
    xmldec: { version: "1.0", encoding: "utf-8" },
    renderOpts: { pretty: true, indent: "  ", newline: "\n" },
    cdata: false, // Disable automatic CDATA, we'll handle it manually
  });

  // Build XML without CDATA handling first
  let xml = builder.buildObject(indexData);

  // Post-process to wrap content in proper CDATA sections
  xml = wrapContentInCdata(xml);

  // Ensure directory exists
  await fs.mkdir(path.dirname(indexPath), { recursive: true });

  await fs.writeFile(indexPath, xml, "utf-8");
}

/**
 * Post-process XML to wrap content in proper CDATA sections
 */
function wrapContentInCdata(xml: string): string {
  // Always wrap changelog content in CDATA (can be plain text or markdown)
  xml = xml.replace(/<changelog>(.*?)<\/changelog>/gs, (match, content) => {
    const trimmedContent = content.trim();
    if (trimmedContent) {
      return `<changelog><![CDATA[${trimmedContent}]]></changelog>`;
    }
    return match;
  });

  // Only wrap description content in CDATA if it's RTF format
  xml = xml.replace(/<description>(.*?)<\/description>/gs, (match, content) => {
    const trimmedContent = content.trim();
    if (trimmedContent.startsWith("{\\rtf1")) {
      return `<description><![CDATA[${trimmedContent}]]></description>`;
    }
    return match;
  });

  return xml;
}
