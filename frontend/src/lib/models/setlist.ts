export interface Setlist extends SetlistCommon {
	id: string;
}

export interface NewSetlist extends SetlistCommon {
	id?: undefined; // explicitly undefined
}

interface SetlistCommon {
	date: string;
	venue: string;
	songs: string[]; // Array of song IDs
}
