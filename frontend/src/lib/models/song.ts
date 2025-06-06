export interface Song {
    id: string;
    name: string;
    length: number; // in seconds
    path: string; // relative path to the project file
}

export interface NewSong {
    id?: undefined; // explicitly undefined
    name: string;
    length: number;
    path: string; // relative path to the project file
}
