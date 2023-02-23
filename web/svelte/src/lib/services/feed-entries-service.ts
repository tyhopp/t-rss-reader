export class FeedEntriesService {
  async getEntries(url: string): Promise<string | undefined> {
    let xml;

    try {
      const response = await fetch(url, {
        method: 'GET'
      });

      xml = await response.text();
    } catch (error) {
      console.error(`Failed to get entries for feed ${url}`);
    }

    return xml;
  }
}
