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

export function isNewSetlist(setlist: Setlist | NewSetlist): setlist is NewSetlist {
    return (setlist as NewSetlist).id === undefined;
}