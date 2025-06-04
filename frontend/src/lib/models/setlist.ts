export interface Setlist {
    id: string;
    date: string;
    venue: string;
    songs: string[]; // Array of song IDs
}

export interface NewSetlist {
    id?: undefined; // explicitly undefined
    date: string;
    venue: string;
    songs: string[]; // Array of song IDs
}
