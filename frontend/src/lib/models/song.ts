export interface Song {
    id: string;
    name: string;
    length: number; // in seconds
    relativePath: string; // relative path to the project file
}

export interface NewSong {
    id?: undefined; // explicitly undefined
    name: string;
    length: number;
    relativePath: string; // relative path to the project file
}

export function isNewSong(song: Song | NewSong): song is NewSong {
    return song.id === undefined;
}