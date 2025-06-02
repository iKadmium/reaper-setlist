export interface Song {
    id: string;
    name: string;
    length: number; // in seconds
}

export interface NewSong {
    id?: undefined; // explicitly undefined
    name: string;
    length: number;
}

export function isNewSong(song: Song | NewSong): song is NewSong {
    return song.id === undefined;
}