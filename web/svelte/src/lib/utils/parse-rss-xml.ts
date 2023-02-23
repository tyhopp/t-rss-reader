export function parseRssXml(url: string, xml: string): XMLDocument | undefined {
  const parser = new DOMParser();
  const doc = parser.parseFromString(xml, 'application/xml');

  if (doc.querySelector('parsererror')) {
    console.error(`Failed to parse xml of RSS feed ${url}`);
    return;
  }

  return doc;
}
