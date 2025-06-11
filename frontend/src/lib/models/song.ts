export interface Song extends SongCommon {
    id: string;
}

export interface NewSong extends SongCommon {
    id?: undefined; // explicitly undefined
}

interface SongCommon {
    name: string;
    length: number;
    path: string;
}