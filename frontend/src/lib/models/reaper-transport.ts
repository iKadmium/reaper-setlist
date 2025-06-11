export const PLAYSTATE_STOPPED = 0;
export const PLAYSTATE_PLAYING = 1;
export const PLAYSTATE_PAUSED = 2;
export const PLAYSTATE_RECORDING = 5;
export const PLAYSTATE_RECORD_PAUSED = 6;
export type PlayState =
    | typeof PLAYSTATE_STOPPED
    | typeof PLAYSTATE_PLAYING
    | typeof PLAYSTATE_PAUSED
    | typeof PLAYSTATE_RECORDING
    | typeof PLAYSTATE_RECORD_PAUSED;

export interface ReaperTransport {
    playState: PlayState;
    positionSeconds: number; // in seconds
    repeatOn: boolean; // true if repeat is on
    positionString: string; // formatted position string (e.g. "1.1.00")
    positionStringBeats: string; // formatted position in beats (e.g. "1.1.00")
}