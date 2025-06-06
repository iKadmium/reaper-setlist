export class ReaperStateAccessor {
    constructor(private section: string, private readonly urlRoot: string, private readonly fetch: typeof globalThis.fetch) { }

    public async getExtState(key: string): Promise<string> {
        const response = await this.fetch(`${this.urlRoot}/GET/EXTSTATE/${this.section}/${key}`, {
            method: 'GET'
        });

        if (response.ok) {
            const resp = await response.text();
            const lines = resp.split('\n');
            const parts = lines[0].split('\t');
            if (parts.length < 4) {
                throw new Error(`Unexpected response format for key ${key}: ${resp}`);
            }
            return parts[3]; // The value is the fourth part
        }
        throw new Error(`Failed to get key ${key}: ${response.statusText}`);
    }

    public async setExtState(key: string, value: string, temp: boolean = false): Promise<void> {
        const url = temp ? `${this.urlRoot}/SET/EXTSTATE/${this.section}/${key}/value` : `${this.urlRoot}/SET/EXTSTATEPERSIST/${this.section}/${key}/${value}`;
        const response = await this.fetch(url, {
            method: 'GET'
        });

        if (!response.ok) {
            throw new Error(`Failed to set key ${key}: ${response.statusText}`);
        }
    }
}