export function formatDuration(seconds: number): string {
	const minutes = Math.floor(seconds / 60);
	const remainingSeconds = Math.floor(seconds % 60);
	return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
}

export function generateUUID(): string {
	if (typeof crypto !== 'undefined' && crypto.randomUUID) {
		return crypto.randomUUID();
	}

	// Fallback: generate a pseudo-UUID using Math.random()
	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
		const r = (Math.random() * 16) | 0;
		const v = c === 'x' ? r : (r & 0x3) | 0x8;
		return v.toString(16);
	});
}

export function chunk<T>(item: T, chunkSize: number = 600): string[] {
	const str = JSON.stringify(item);
	const chunks: string[] = [];

	for (let i = 0; i < str.length; i += chunkSize) {
		const substr = str.substring(i, i + chunkSize);
		chunks.push(substr);
	}

	return chunks;
}
