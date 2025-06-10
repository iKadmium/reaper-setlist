---@diagnostic disable

-- REAPER API LuaDoc Type Definitions
-- Auto-generated from REAPER API documentation
-- Generated from REAPER v7.39
-- Generated on: 2025-06-10T04:59:22.074Z
--
-- This file provides type definitions for VS Code autocompletion
-- when working with REAPER Lua scripts.

---

---@class AudioAccessor
---@class HWND
---@class IReaperControlSurface
---@class KbdSectionInfo
---@class MediaItem
---@class MediaItem_Take
---@class MediaTrack
---@class PCM_source
---@class ReaProject
---@class TrackEnvelope
---@class identifier
---@class joystick_device

---@class ReaperArray
local ReaperArray = {}

---@param value number
---@param offset integer
---@param size integer
--- Sets the value of zero or more items in the array. If value not specified, 0.0 is used. offset is 1-based, if size omitted then the maximum amount available will be set.
function ReaperArray:clear(value, offset, size) end

---@param src ReaperArray|table
---@param srcoffs integer
---@param size integer
---@param destoffs integer
--- Convolves complex value pairs from reaper.array, starting at 1-based srcoffs, reading/writing to 1-based destoffs. size is in normal items (so it must be even)
function ReaperArray:convolve(src, srcoffs, size, destoffs) end

---@param src ReaperArray|table
---@param srcoffs integer
---@param size integer
---@param destoffs integer
--- Copies values from reaper.array or table, starting at 1-based srcoffs, writing to 1-based destoffs.
function ReaperArray:copy(src, srcoffs, size, destoffs) end

---@param size integer
---@param permute boolean
---@param offset integer
--- Performs a forward FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled following the FFT to be in normal order.
function ReaperArray:fft(size, permute, offset) end

---@param size integer
---@param permute boolean
---@param offset integer
--- Performs a forward real->complex FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled following the FFT to be in normal order.
function ReaperArray:fft_real(size, permute, offset) end

--- Returns the maximum (allocated) size of the array.
function ReaperArray:get_alloc() end

---@param size integer
---@param permute boolean
---@param offset integer
--- Performs a backwards FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled before the IFFT to be in fft-order.
function ReaperArray:ifft(size, permute, offset) end

---@param size integer
---@param permute boolean
---@param offset integer
--- Performs a backwards complex->real FFT of size. size must be a power of two between 4 and 32768 inclusive. If permute is specified and true, the values will be shuffled before the IFFT to be in fft-order.
function ReaperArray:ifft_real(size, permute, offset) end

---@param src ReaperArray|table
---@param srcoffs integer
---@param size integer
---@param destoffs integer
--- Multiplies values from reaper.array, starting at 1-based srcoffs, reading/writing to 1-based destoffs.
function ReaperArray:multiply(src, srcoffs, size, destoffs) end

---@param size integer
--- Resizes an array object to size. size must be [0..max_size].
function ReaperArray:resize(size) end

---@param offset integer
---@param size integer
--- Returns a new table with values from items in the array. Offset is 1-based and if size is omitted all available values are used.
function ReaperArray:table(offset, size) end

---@class reaper
reaper = {}

---@param tr MediaTrack
---@return MediaItem
--- creates a new media item.
function reaper.AddMediaItemToTrack(tr) end

---@param proj ReaProject
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param wantidx integer
---@return integer
--- Returns the index of the created marker/region, or -1 on failure. Supply wantidx>=0 if you want a particular index number, but you'll get a different index number a region and wantidx is already in use.
function reaper.AddProjectMarker(proj, isrgn, pos, rgnend, name, wantidx) end

---@param proj ReaProject
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param wantidx integer
---@param color integer
---@return integer
--- Returns the index of the created marker/region, or -1 on failure. Supply wantidx>=0 if you want a particular index number, but you'll get a different index number a region and wantidx is already in use. color should be 0 (default color), or ColorToNative(r,g,b)|0x1000000
function reaper.AddProjectMarker2(proj, isrgn, pos, rgnend, name, wantidx, color) end

---@param add boolean
---@param sectionID integer
---@param scriptfn string
---@param commit boolean
---@return integer
--- Add a ReaScript (return the new command ID, or 0 if failed) or remove a ReaScript (return >0 on success). Use commit==true when adding/removing a single script. When bulk adding/removing n scripts, you can optimize the n-1 first calls with commit==false and commit==true for the last call.
function reaper.AddRemoveReaScript(add, sectionID, scriptfn, commit) end

---@param item MediaItem
---@return MediaItem_Take
--- creates a new take in an item
function reaper.AddTakeToMediaItem(item) end

---@param proj ReaProject
---@param timepos number
---@param bpm number
---@param timesig_num integer
---@param timesig_denom integer
---@param lineartempochange boolean
---@return boolean
--- Deprecated. Use SetTempoTimeSigMarker with ptidx=-1.
function reaper.AddTempoTimeSigMarker(proj, timepos, bpm, timesig_num, timesig_denom, lineartempochange) end

---@param amt number
---@param forceset integer
---@param doupd boolean
---@param centermode integer
--- forceset=0,doupd=true,centermode=-1 for default
function reaper.adjustZoom(amt, forceset, doupd, centermode) end

---@param proj ReaProject
---@return boolean
function reaper.AnyTrackSolo(proj) end

---@param function_name string
---@return boolean
--- Returns true if function_name exists in the REAPER API
function reaper.APIExists(function_name) end

--- Displays a message window if the API was successfully called.
function reaper.APITest() end

---@param project ReaProject
---@param nudgeflag integer
---@param nudgewhat integer
---@param nudgeunits integer
---@param value number
---@param reverse boolean
---@param copies integer
---@return boolean
--- nudgeflag: &1=set to value (otherwise nudge by value), &2=snap nudgewhat: 0=position, 1=left trim, 2=left edge, 3=right edge, 4=contents, 5=duplicate, 6=edit cursor nudgeunit: 0=ms, 1=seconds, 2=grid, 3=256th notes, ..., 15=whole notes, 16=measures.beats (1.15 = 1 measure + 1.5 beats), 17=samples, 18=frames, 19=pixels, 20=item lengths, 21=item selections value: amount to nudge by, or value to set to reverse: in nudge mode, nudges left (otherwise ignored) copies: in nudge duplicate mode, number of copies (otherwise ignored)
function reaper.ApplyNudge(project, nudgeflag, nudgewhat, nudgeunits, value, reverse, copies) end

---@param cmd integer
---@param sectionname string
--- arms a command (or disarms if 0 passed) in section sectionname (empty string for main)
function reaper.ArmCommand(cmd, sectionname) end

--- open all audio and MIDI devices, if not open
function reaper.Audio_Init() end

---@return integer
--- is in pre-buffer? threadsafe
function reaper.Audio_IsPreBuffer() end

---@return integer
--- is audio running at all? threadsafe
function reaper.Audio_IsRunning() end

--- close all audio and MIDI devices, if open
function reaper.Audio_Quit() end

---@param accessor AudioAccessor
---@return boolean
--- Returns true if the underlying samples (track or media item take) have changed, but does not update the audio accessor, so the user can selectively call AudioAccessorValidateState only when needed. See CreateTakeAudioAccessor , CreateTrackAudioAccessor , DestroyAudioAccessor , GetAudioAccessorEndTime , GetAudioAccessorSamples.
function reaper.AudioAccessorStateChanged(accessor) end

---@param accessor AudioAccessor
--- Force the accessor to reload its state from the underlying track or media item take. See CreateTakeAudioAccessor , CreateTrackAudioAccessor , DestroyAudioAccessor , AudioAccessorStateChanged , GetAudioAccessorStartTime , GetAudioAccessorEndTime , GetAudioAccessorSamples.
function reaper.AudioAccessorUpdate(accessor) end

---@param accessor AudioAccessor
---@return boolean
--- Validates the current state of the audio accessor -- must ONLY call this from the main thread. Returns true if the state changed.
function reaper.AudioAccessorValidateState(accessor) end

---@param bypass integer
--- -1 = bypass all if not all bypassed,otherwise unbypass all
function reaper.BypassFxAllTracks(bypass) end

---@param mediasource PCM_source
---@return integer
--- Calculates loudness statistics of media via dry run render. Statistics will be displayed to the user; call GetSetProjectInfo_String("RENDER_STATS") to retrieve via API. Returns 1 if loudness was calculated successfully, -1 if user canceled the dry run render.
function reaper.CalcMediaSrcLoudness(mediasource) end

---@param source PCM_source
---@param normalizeTo integer
---@param normalizeTarget number
---@param normalizeStart number
---@param normalizeEnd number
---@return number
--- Calculate normalize adjustment for source media. normalizeTo: 0=LUFS-I, 1=RMS-I, 2=peak, 3=true peak, 4=LUFS-M max, 5=LUFS-S max. normalizeTarget: dBFS or LUFS value. normalizeStart, normalizeEnd: time bounds within source media for normalization calculation. If normalizationStart=0 and normalizationEnd=0, the full duration of the media will be used for the calculation.
function reaper.CalculateNormalization(source, normalizeTo, normalizeTarget, normalizeStart, normalizeEnd) end

function reaper.ClearAllRecArmed() end

--- Clear the ReaScript console. See ShowConsoleMsg
function reaper.ClearConsole() end

--- resets the global peak caches
function reaper.ClearPeakCache() end

---@param col integer
---@return integer r, integer g, integer b
--- Extract RGB values from an OS dependent color. See ColorToNative.
function reaper.ColorFromNative(col) end

---@param r integer
---@param g integer
---@param b integer
---@return integer
--- Make an OS dependent color from RGB values (e.g. RGB() macro on Windows). r,g and b are in [0..255]. See ColorFromNative.
function reaper.ColorToNative(r, g, b) end

---@param section KbdSectionInfo
---@param cmdID integer
---@return integer
--- Returns the number of shortcuts that exist for the given command ID. see GetActionShortcutDesc , DeleteActionShortcut , DoActionShortcutDialog.
function reaper.CountActionShortcuts(section, cmdID) end

---@param env TrackEnvelope
---@return integer
--- Returns the number of automation items on this envelope. See GetSetAutomationItemInfo
function reaper.CountAutomationItems(env) end

---@param envelope TrackEnvelope
---@return integer
--- Returns the number of points in the envelope. See CountEnvelopePointsEx.
function reaper.CountEnvelopePoints(envelope) end

---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@return integer
--- Returns the number of points in the envelope. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc. For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration, even if the automation item is trimmed so that not all points are visible. Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations. See GetEnvelopePointEx , SetEnvelopePointEx , InsertEnvelopePointEx , DeleteEnvelopePointEx.
function reaper.CountEnvelopePointsEx(envelope, autoitem_idx) end

---@param proj ReaProject
---@return integer
--- count the number of items in the project (proj=0 for active project)
function reaper.CountMediaItems(proj) end

---@param proj ReaProject
---@return integer retval, integer num_markers, integer num_regions
--- num_markersOut and num_regionsOut may be NULL.
function reaper.CountProjectMarkers(proj) end

---@param proj ReaProject
---@return integer
--- Discouraged, because GetSelectedMediaItem can be inefficient if media items are added, rearranged, or deleted in between calls. Instead see CountMediaItems , GetMediaItem , IsMediaItemSelected.
function reaper.CountSelectedMediaItems(proj) end

---@param proj ReaProject
---@return integer
--- Count the number of selected tracks in the project (proj=0 for active project). This function ignores the master track, see CountSelectedTracks2.
function reaper.CountSelectedTracks(proj) end

---@param proj ReaProject
---@param wantmaster boolean
---@return integer
--- Count the number of selected tracks in the project (proj=0 for active project).
function reaper.CountSelectedTracks2(proj, wantmaster) end

---@param take MediaItem_Take
---@return integer
--- See GetTakeEnvelope
function reaper.CountTakeEnvelopes(take) end

---@param item MediaItem
---@return integer
--- count the number of takes in the item
function reaper.CountTakes(item) end

---@param project ReaProject
---@param track MediaTrack
---@return integer
--- Count the number of FX parameter knobs displayed on the track control panel.
function reaper.CountTCPFXParms(project, track) end

---@param proj ReaProject
---@return integer
--- Count the number of tempo/time signature markers in the project. See GetTempoTimeSigMarker , SetTempoTimeSigMarker , AddTempoTimeSigMarker.
function reaper.CountTempoTimeSigMarkers(proj) end

---@param track MediaTrack
---@return integer
--- see GetTrackEnvelope
function reaper.CountTrackEnvelopes(track) end

---@param track MediaTrack
---@return integer
--- count the number of items in the track
function reaper.CountTrackMediaItems(track) end

---@param proj ReaProject
---@return integer
--- count the number of tracks in the project (proj=0 for active project)
function reaper.CountTracks(proj) end

---@param track MediaTrack
---@param starttime number
---@param endtime number
---@param qnIn optional boolean
---@return MediaItem
--- Create a new MIDI media item, containing no MIDI events. Time is in seconds unless qn is set.
function reaper.CreateNewMIDIItemInProj(track, starttime, endtime, qnIn) end

---@param take MediaItem_Take
---@return AudioAccessor
--- Create an audio accessor object for this take. Must only call from the main thread. See CreateTrackAudioAccessor , DestroyAudioAccessor , AudioAccessorStateChanged , GetAudioAccessorStartTime , GetAudioAccessorEndTime , GetAudioAccessorSamples.
function reaper.CreateTakeAudioAccessor(take) end

---@param track MediaTrack
---@return AudioAccessor
--- Create an audio accessor object for this track. Must only call from the main thread. See CreateTakeAudioAccessor , DestroyAudioAccessor , AudioAccessorStateChanged , GetAudioAccessorStartTime , GetAudioAccessorEndTime , GetAudioAccessorSamples.
function reaper.CreateTrackAudioAccessor(track) end

---@param tr MediaTrack
---@param desttrIn MediaTrack
---@return integer
--- Create a send/receive (desttrInOptional!=NULL), or a hardware output (desttrInOptional==NULL) with default properties, return >=0 on success (== new send/receive index). See RemoveTrackSend , GetSetTrackSendInfo , GetTrackSendInfo_Value , SetTrackSendInfo_Value.
function reaper.CreateTrackSend(tr, desttrIn) end

---@param force boolean
--- call this to force flushing of the undo states after using CSurf_On*Change()
function reaper.CSurf_FlushUndo(force) end

---@param trackid MediaTrack
---@param isPan integer
---@return boolean
function reaper.CSurf_GetTouchState(trackid, isPan) end

function reaper.CSurf_GoEnd() end

function reaper.CSurf_GoStart() end

---@param mcpView boolean
---@return integer
function reaper.CSurf_NumTracks(mcpView) end

---@param whichdir integer
---@param wantzoom boolean
function reaper.CSurf_OnArrow(whichdir, wantzoom) end

---@param seekplay integer
function reaper.CSurf_OnFwd(seekplay) end

---@param trackid MediaTrack
---@param en integer
---@return boolean
function reaper.CSurf_OnFXChange(trackid, en) end

---@param trackid MediaTrack
---@param monitor integer
---@return integer
function reaper.CSurf_OnInputMonitorChange(trackid, monitor) end

---@param trackid MediaTrack
---@param monitor integer
---@param allowgang boolean
---@return integer
function reaper.CSurf_OnInputMonitorChangeEx(trackid, monitor, allowgang) end

---@param trackid MediaTrack
---@param mute integer
---@return boolean
function reaper.CSurf_OnMuteChange(trackid, mute) end

---@param trackid MediaTrack
---@param mute integer
---@param allowgang boolean
---@return boolean
function reaper.CSurf_OnMuteChangeEx(trackid, mute, allowgang) end

---@param trackid MediaTrack
---@param pan number
---@param relative boolean
---@return number
function reaper.CSurf_OnPanChange(trackid, pan, relative) end

---@param trackid MediaTrack
---@param pan number
---@param relative boolean
---@param allowGang boolean
---@return number
function reaper.CSurf_OnPanChangeEx(trackid, pan, relative, allowGang) end

function reaper.CSurf_OnPause() end

function reaper.CSurf_OnPlay() end

---@param playrate number
function reaper.CSurf_OnPlayRateChange(playrate) end

---@param trackid MediaTrack
---@param recarm integer
---@return boolean
function reaper.CSurf_OnRecArmChange(trackid, recarm) end

---@param trackid MediaTrack
---@param recarm integer
---@param allowgang boolean
---@return boolean
function reaper.CSurf_OnRecArmChangeEx(trackid, recarm, allowgang) end

function reaper.CSurf_OnRecord() end

---@param trackid MediaTrack
---@param recv_index integer
---@param pan number
---@param relative boolean
---@return number
function reaper.CSurf_OnRecvPanChange(trackid, recv_index, pan, relative) end

---@param trackid MediaTrack
---@param recv_index integer
---@param volume number
---@param relative boolean
---@return number
function reaper.CSurf_OnRecvVolumeChange(trackid, recv_index, volume, relative) end

---@param seekplay integer
function reaper.CSurf_OnRew(seekplay) end

---@param seekplay integer
---@param dir integer
function reaper.CSurf_OnRewFwd(seekplay, dir) end

---@param xdir integer
---@param ydir integer
function reaper.CSurf_OnScroll(xdir, ydir) end

---@param trackid MediaTrack
---@param selected integer
---@return boolean
function reaper.CSurf_OnSelectedChange(trackid, selected) end

---@param trackid MediaTrack
---@param send_index integer
---@param pan number
---@param relative boolean
---@return number
function reaper.CSurf_OnSendPanChange(trackid, send_index, pan, relative) end

---@param trackid MediaTrack
---@param send_index integer
---@param volume number
---@param relative boolean
---@return number
function reaper.CSurf_OnSendVolumeChange(trackid, send_index, volume, relative) end

---@param trackid MediaTrack
---@param solo integer
---@return boolean
function reaper.CSurf_OnSoloChange(trackid, solo) end

---@param trackid MediaTrack
---@param solo integer
---@param allowgang boolean
---@return boolean
function reaper.CSurf_OnSoloChangeEx(trackid, solo, allowgang) end

function reaper.CSurf_OnStop() end

---@param bpm number
function reaper.CSurf_OnTempoChange(bpm) end

---@param trackid MediaTrack
function reaper.CSurf_OnTrackSelection(trackid) end

---@param trackid MediaTrack
---@param volume number
---@param relative boolean
---@return number
function reaper.CSurf_OnVolumeChange(trackid, volume, relative) end

---@param trackid MediaTrack
---@param volume number
---@param relative boolean
---@param allowGang boolean
---@return number
function reaper.CSurf_OnVolumeChangeEx(trackid, volume, relative, allowGang) end

---@param trackid MediaTrack
---@param width number
---@param relative boolean
---@return number
function reaper.CSurf_OnWidthChange(trackid, width, relative) end

---@param trackid MediaTrack
---@param width number
---@param relative boolean
---@param allowGang boolean
---@return number
function reaper.CSurf_OnWidthChangeEx(trackid, width, relative, allowGang) end

---@param xdir integer
---@param ydir integer
function reaper.CSurf_OnZoom(xdir, ydir) end

function reaper.CSurf_ResetAllCachedVolPanStates() end

---@param amt number
function reaper.CSurf_ScrubAmt(amt) end

---@param mode integer
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetAutoMode(mode, ignoresurf) end

---@param play boolean
---@param pause boolean
---@param rec boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetPlayState(play, pause, rec, ignoresurf) end

---@param rep boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetRepeatState(rep, ignoresurf) end

---@param trackid MediaTrack
---@param mute boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceMute(trackid, mute, ignoresurf) end

---@param trackid MediaTrack
---@param pan number
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfacePan(trackid, pan, ignoresurf) end

---@param trackid MediaTrack
---@param recarm boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceRecArm(trackid, recarm, ignoresurf) end

---@param trackid MediaTrack
---@param selected boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceSelected(trackid, selected, ignoresurf) end

---@param trackid MediaTrack
---@param solo boolean
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceSolo(trackid, solo, ignoresurf) end

---@param trackid MediaTrack
---@param volume number
---@param ignoresurf IReaperControlSurface
function reaper.CSurf_SetSurfaceVolume(trackid, volume, ignoresurf) end

function reaper.CSurf_SetTrackListChange() end

---@param idx integer
---@param mcpView boolean
---@return MediaTrack
function reaper.CSurf_TrackFromID(idx, mcpView) end

---@param track MediaTrack
---@param mcpView boolean
---@return integer
function reaper.CSurf_TrackToID(track, mcpView) end

---@param x number
---@return number
function reaper.DB2SLIDER(x) end

---@param section KbdSectionInfo
---@param cmdID integer
---@param shortcutidx integer
---@return boolean
--- Delete the specific shortcut for the given command ID. See CountActionShortcuts , GetActionShortcutDesc , DoActionShortcutDialog.
function reaper.DeleteActionShortcut(section, cmdID, shortcutidx) end

---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param ptidx integer
---@return boolean
--- Delete an envelope point. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc. For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration, even if the automation item is trimmed so that not all points are visible. Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations. See CountEnvelopePointsEx , GetEnvelopePointEx , SetEnvelopePointEx , InsertEnvelopePointEx.
function reaper.DeleteEnvelopePointEx(envelope, autoitem_idx, ptidx) end

---@param envelope TrackEnvelope
---@param time_start number
---@param time_end number
---@return boolean
--- Delete a range of envelope points. See DeleteEnvelopePointRangeEx , DeleteEnvelopePointEx.
function reaper.DeleteEnvelopePointRange(envelope, time_start, time_end) end

---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param time_start number
---@param time_end number
---@return boolean
--- Delete a range of envelope points. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc.
function reaper.DeleteEnvelopePointRangeEx(envelope, autoitem_idx, time_start, time_end) end

---@param section string
---@param key string
---@param persist boolean
--- Delete the extended state value for a specific section and key. persist=true means the value should remain deleted the next time REAPER is opened. See SetExtState , GetExtState , HasExtState.
function reaper.DeleteExtState(section, key, persist) end

---@param proj ReaProject
---@param markrgnindexnumber integer
---@param isrgn boolean
---@return boolean
--- Delete a marker. proj==NULL for the active project.
function reaper.DeleteProjectMarker(proj, markrgnindexnumber, isrgn) end

---@param proj ReaProject
---@param markrgnidx integer
---@return boolean
--- Differs from DeleteProjectMarker only in that markrgnidx is 0 for the first marker/region, 1 for the next, etc (see EnumProjectMarkers3 ), rather than representing the displayed marker/region ID number (see SetProjectMarker4 ).
function reaper.DeleteProjectMarkerByIndex(proj, markrgnidx) end

---@param take MediaItem_Take
---@param idx integer
---@return boolean
--- Delete a take marker. Note that idx will change for all following take markers. See GetNumTakeMarkers , GetTakeMarker , SetTakeMarker
function reaper.DeleteTakeMarker(take, idx) end

---@param take MediaItem_Take
---@param idx integer
---@param countIn optional integer
---@return integer
--- Deletes one or more stretch markers. Returns number of stretch markers deleted.
function reaper.DeleteTakeStretchMarkers(take, idx, countIn) end

---@param project ReaProject
---@param markerindex integer
---@return boolean
--- Delete a tempo/time signature marker.
function reaper.DeleteTempoTimeSigMarker(project, markerindex) end

---@param tr MediaTrack
--- deletes a track
function reaper.DeleteTrack(tr) end

---@param tr MediaTrack
---@param it MediaItem
---@return boolean
function reaper.DeleteTrackMediaItem(tr, it) end

---@param accessor AudioAccessor
--- Destroy an audio accessor. Must only call from the main thread. See CreateTakeAudioAccessor , CreateTrackAudioAccessor , AudioAccessorStateChanged , GetAudioAccessorStartTime , GetAudioAccessorEndTime , GetAudioAccessorSamples.
function reaper.DestroyAudioAccessor(accessor) end

---@param hwnd HWND
---@param section KbdSectionInfo
---@param cmdID integer
---@param shortcutidx integer
---@return boolean
--- Open the action shortcut dialog to edit or add a shortcut for the given command ID. If (shortcutidx >= 0 && shortcutidx < CountActionShortcuts()), that specific shortcut will be replaced, otherwise a new shortcut will be added. See CountActionShortcuts , GetActionShortcutDesc , DeleteActionShortcut.
function reaper.DoActionShortcutDialog(hwnd, section, cmdID, shortcutidx) end

---@param ident_str string
---@param whichDock integer
--- updates preference for docker window ident_str to be in dock whichDock on next open
function reaper.Dock_UpdateDockID(ident_str, whichDock) end

---@param whichDock integer
---@return integer
--- -1=not found, 0=bottom, 1=left, 2=top, 3=right, 4=floating
function reaper.DockGetPosition(whichDock) end

---@param hwnd HWND
---@return integer retval, boolean isFloatingDocker
--- returns dock index that contains hwnd, or -1
function reaper.DockIsChildOfDock(hwnd) end

---@param hwnd HWND
function reaper.DockWindowActivate(hwnd) end

---@param hwnd HWND
---@param name string
---@param pos integer
---@param allowShow boolean
function reaper.DockWindowAdd(hwnd, name, pos, allowShow) end

---@param hwnd HWND
---@param name string
---@param identstr string
---@param allowShow boolean
function reaper.DockWindowAddEx(hwnd, name, identstr, allowShow) end

function reaper.DockWindowRefresh() end

---@param hwnd HWND
function reaper.DockWindowRefreshForHWND(hwnd) end

---@param hwnd HWND
function reaper.DockWindowRemove(hwnd) end

---@param project ReaProject
---@param markerindex integer
---@return boolean
--- Open the tempo/time signature marker editor dialog.
function reaper.EditTempoTimeSigMarker(project, markerindex) end

---@return integerr.left, integerr.top, integerr.right, integerr.bot
--- call with a saved window rect for your window and it'll correct any positioning info.
function reaper.EnsureNotCompletelyOffscreen() end

---@param path string
---@param fileindex integer
---@return string
--- List the files in the "path" directory. Returns NULL/nil when all files have been listed. Use fileindex = -1 to force re-read of directory (invalidate cache). See EnumerateSubdirectories
function reaper.EnumerateFiles(path, fileindex) end

---@param path string
---@param subdirindex integer
---@return string
--- List the subdirectories in the "path" directory. Use subdirindex = -1 to force re-read of directory (invalidate cache). Returns NULL/nil when all subdirectories have been listed. See EnumerateFiles
function reaper.EnumerateSubdirectories(path, subdirindex) end

---@param index integer
---@return boolean retval, string name, string ident
--- Enumerates installed FX. Returns true if successful, sets nameOut and identOut to name and ident of FX at index.
function reaper.EnumInstalledFX(index) end

---@param mode integer
---@return boolean retval, string str
--- Start querying modes at 0, returns FALSE when no more modes possible, sets strOut to NULL if a mode is currently unsupported
function reaper.EnumPitchShiftModes(mode) end

---@param mode integer
---@param submode integer
---@return string
--- Returns submode name, or NULL
function reaper.EnumPitchShiftSubModes(mode, submode) end

---@param idx integer
---@return integer retval, boolean isrgn, number pos, number rgnend, string name, integer markrgnindexnumber
function reaper.EnumProjectMarkers(idx) end

---@param proj ReaProject
---@param idx integer
---@return integer retval, boolean isrgn, number pos, number rgnend, string name, integer markrgnindexnumber
function reaper.EnumProjectMarkers2(proj, idx) end

---@param proj ReaProject
---@param idx integer
---@return integer retval, boolean isrgn, number pos, number rgnend, string name, integer markrgnindexnumber, integer color
function reaper.EnumProjectMarkers3(proj, idx) end

---@param idx integer
---@return ReaProject retval, string projfn
--- idx=-1 for current project,projfn can be NULL if not interested in filename. use idx 0x40000000 for currently rendering project, if any.
function reaper.EnumProjects(idx) end

---@param proj ReaProject
---@param extname string
---@param idx integer
---@return boolean retval, string key, string val
--- Enumerate the data stored with the project for a specific extname. Returns false when there is no more data. See SetProjExtState , GetProjExtState.
function reaper.EnumProjExtState(proj, extname, idx) end

---@param proj ReaProject
---@param regionindex integer
---@param rendertrack integer
---@return MediaTrack
--- Enumerate which tracks will be rendered within this region when using the region render matrix. When called with rendertrack==0, the function returns the first track that will be rendered (which may be the master track); rendertrack==1 will return the next track rendered, and so on. The function returns NULL when there are no more tracks that will be rendered within this region.
function reaper.EnumRegionRenderMatrix(proj, regionindex, rendertrack) end

---@param track integer
---@param programNumber integer
---@param programName string
---@return boolean retval, string programName
--- returns false if there are no plugins on the track that support MIDI programs,or if all programs have been enumerated
function reaper.EnumTrackMIDIProgramNames(track, programNumber, programName) end

---@param proj ReaProject
---@param track MediaTrack
---@param programNumber integer
---@param programName string
---@return boolean retval, string programName
--- returns false if there are no plugins on the track that support MIDI programs,or if all programs have been enumerated
function reaper.EnumTrackMIDIProgramNamesEx(proj, track, programNumber, programName) end

---@param envelope TrackEnvelope
---@param time number
---@param samplerate number
---@param samplesRequested integer
---@return integer retval, number value, number dVdS, number ddVdS, number dddVdS
--- Get the effective envelope value at a given time position. samplesRequested is how long the caller expects until the next call to Envelope_Evaluate (often, the buffer block size). The return value is how many samples beyond that time position that the returned values are valid. dVdS is the change in value per sample (first derivative), ddVdS is the second derivative, dddVdS is the third derivative. See GetEnvelopeScalingMode.
function reaper.Envelope_Evaluate(envelope, time, samplerate, samplesRequested) end

---@param env TrackEnvelope
---@param value number
---@return string buf
--- Formats the value of an envelope to a user-readable form
function reaper.Envelope_FormatValue(env, value) end

---@param env TrackEnvelope
---@return MediaItem_Take retval, integer index, integer index2
--- If take envelope, gets the take from the envelope. If FX, indexOut set to FX index, index2Out set to parameter index, otherwise -1.
function reaper.Envelope_GetParentTake(env) end

---@param env TrackEnvelope
---@return MediaTrack retval, integer index, integer index2
--- If track envelope, gets the track from the envelope. If FX, indexOut set to FX index, index2Out set to parameter index, otherwise -1.
function reaper.Envelope_GetParentTrack(env) end

---@param envelope TrackEnvelope
---@return boolean
--- Sort envelope points by time. See SetEnvelopePoint , InsertEnvelopePoint.
function reaper.Envelope_SortPoints(envelope) end

---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@return boolean
--- Sort envelope points by time. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc. See SetEnvelopePoint , InsertEnvelopePoint.
function reaper.Envelope_SortPointsEx(envelope, autoitem_idx) end

---@param cmdline string
---@param timeoutmsec integer
---@return string
--- Executes command line, returns NULL on total failure, otherwise the return value, a newline, and then the output of the command. If timeoutmsec is 0, command will be allowed to run indefinitely (recommended for large amounts of returned output). timeoutmsec is -1 for no wait/terminate, -2 for no wait and minimize
function reaper.ExecProcess(cmdline, timeoutmsec) end

---@param path string
---@return boolean
--- returns true if path points to a valid, readable file
function reaper.file_exists(path) end

---@param project ReaProject
---@param time number
---@return integer
--- Find the tempo/time signature marker that falls at or before this time position (the marker that is in effect as of this time position).
function reaper.FindTempoTimeSigMarker(project, time) end

---@param tpos number
---@param buf string
---@return string buf
--- Format tpos (which is time in seconds) as hh:mm:ss.sss. See format_timestr_pos , format_timestr_len.
function reaper.format_timestr(tpos, buf) end

---@param tpos number
---@param buf string
---@param offset number
---@param modeoverride integer
---@return string buf
--- time formatting mode overrides: -1=proj default. 0=time 1=measures.beats + time 2=measures.beats 3=seconds 4=samples 5=h:m:s:f offset is start of where the length will be calculated from
function reaper.format_timestr_len(tpos, buf, offset, modeoverride) end

---@param tpos number
---@param buf string
---@param modeoverride integer
---@return string buf
--- time formatting mode overrides: -1=proj default. 0=time 1=measures.beats + time 2=measures.beats 3=seconds 4=samples 5=h:m:s:f
function reaper.format_timestr_pos(tpos, buf, modeoverride) end

---@param gGUID string
---@return string gGUID
function reaper.genGuid(gGUID) end

---@param name string
---@return boolean retval, string buf
--- gets ini configuration variable value as string
function reaper.get_config_var_string(name) end

---@return string
--- Get reaper.ini full filename.
function reaper.get_ini_file() end

---@param section KbdSectionInfo
---@param cmdID integer
---@param shortcutidx integer
---@return boolean retval, string desc
--- Get the text description of a specific shortcut for the given command ID. See CountActionShortcuts , DeleteActionShortcut , DoActionShortcutDialog.
function reaper.GetActionShortcutDesc(section, cmdID, shortcutidx) end

---@param item MediaItem
---@return MediaItem_Take
--- get the active take in this item
function reaper.GetActiveTake(item) end

---@param ignoreProject ReaProject
---@return integer
--- returns the bitwise OR of all project play states (1=playing, 2=pause, 4=recording)
function reaper.GetAllProjectPlayStates(ignoreProject) end

---@return string
--- Returns app version which may include an OS/arch signifier, such as: "6.17" (windows 32-bit), "6.17/x64" (windows 64-bit), "6.17/OSX64" (macOS 64-bit Intel), "6.17/OSX" (macOS 32-bit), "6.17/macOS-arm64", "6.17/linux-x86_64", "6.17/linux-i686", "6.17/linux-aarch64", "6.17/linux-armv7l", etc
function reaper.GetAppVersion() end

---@return integer retval, string sec
--- gets the currently armed command and section name (returns 0 if nothing armed). section name is empty-string for main section.
function reaper.GetArmedCommand() end

---@param accessor AudioAccessor
---@return number
--- Get the end time of the audio that can be returned from this accessor. See CreateTakeAudioAccessor , CreateTrackAudioAccessor , DestroyAudioAccessor , AudioAccessorStateChanged , GetAudioAccessorStartTime , GetAudioAccessorSamples.
function reaper.GetAudioAccessorEndTime(accessor) end

---@param accessor AudioAccessor
---@param hashNeed128 string
---@return string hashNeed128
--- Deprecated. See AudioAccessorStateChanged instead.
function reaper.GetAudioAccessorHash(accessor, hashNeed128) end

---@param accessor AudioAccessor
---@param samplerate integer
---@param numchannels integer
---@param starttime_sec number
---@param numsamplesperchannel integer
---@param samplebuffer ReaperArray
---@return integer
--- Get a block of samples from the audio accessor. Samples are extracted immediately pre-FX, and returned interleaved (first sample of first channel, first sample of second channel...). Returns 0 if no audio, 1 if audio, -1 on error. See CreateTakeAudioAccessor , CreateTrackAudioAccessor , DestroyAudioAccessor , AudioAccessorStateChanged , GetAudioAccessorStartTime , GetAudioAccessorEndTime . This function has special handling in Python, and only returns two objects, the API function return value, and the sample buffer. Example usage: tr = RPR_GetTrack(0, 0) aa = RPR_CreateTrackAudioAccessor(tr) buf = list([0]*2*1024) # 2 channels, 1024 samples each, initialized to zero pos = 0.0 (ret, buf) = GetAudioAccessorSamples(aa, 44100, 2, pos, 1024, buf) # buf now holds the first 2*1024 audio samples from the track. # typically GetAudioAccessorSamples() would be called within a loop, increasing pos each time.
function reaper.GetAudioAccessorSamples(accessor, samplerate, numchannels, starttime_sec, numsamplesperchannel,
                                        samplebuffer)
end

---@param accessor AudioAccessor
---@return number
--- Get the start time of the audio that can be returned from this accessor. See CreateTakeAudioAccessor , CreateTrackAudioAccessor , DestroyAudioAccessor , AudioAccessorStateChanged , GetAudioAccessorEndTime , GetAudioAccessorSamples.
function reaper.GetAudioAccessorStartTime(accessor) end

---@param attribute string
---@return boolean retval, string desc
--- get information about the currently open audio device. attribute can be MODE, IDENT_IN, IDENT_OUT, BSIZE, SRATE, BPS. returns false if unknown attribute or device not open.
function reaper.GetAudioDeviceInfo(attribute) end

---@param ident_str string
---@return integer
--- gets the dock ID desired by ident_str, if any
function reaper.GetConfigWantsDock(ident_str) end

---@return ReaProject
--- returns current project if in load/save (usually only used from project_config_extension_t)
function reaper.GetCurrentProjectInLoadSave() end

---@return integer
--- return the current cursor context: 0 if track panels, 1 if items, 2 if envelopes, otherwise unknown
function reaper.GetCursorContext() end

---@param want_last_valid boolean
---@return integer
--- 0 if track panels, 1 if items, 2 if envelopes, otherwise unknown (unlikely when want_last_valid is true)
function reaper.GetCursorContext2(want_last_valid) end

---@return number
--- edit cursor position
function reaper.GetCursorPosition() end

---@param proj ReaProject
---@return number
--- edit cursor position
function reaper.GetCursorPositionEx(proj) end

---@param item MediaItem
---@return integer
--- see GetDisplayedMediaItemColor2.
function reaper.GetDisplayedMediaItemColor(item) end

---@param item MediaItem
---@param take MediaItem_Take
---@return integer
--- Returns the custom take, item, or track color that is used (according to the user preference) to color the media item. The returned color is OS dependent|0x01000000 (i.e. ColorToNative(r,g,b)|0x01000000), so a return of zero means "no color", not black.
function reaper.GetDisplayedMediaItemColor2(item, take) end

---@param env TrackEnvelope
---@param parmname string
---@return number
--- Gets an envelope numerical-value attribute: I_TCPY : int : Y offset of envelope relative to parent track (may be separate lane or overlap with track contents) I_TCPH : int : visible height of envelope I_TCPY_USED : int : Y offset of envelope relative to parent track, exclusive of padding I_TCPH_USED : int : visible height of envelope, exclusive of padding P_TRACK : MediaTrack * : parent track pointer (if any) P_DESTTRACK : MediaTrack * : destination track pointer, if on a send P_ITEM : MediaItem * : parent item pointer (if any) P_TAKE : MediaItem_Take * : parent take pointer (if any) I_SEND_IDX : int : 1-based index of send in P_TRACK, or 0 if not a send I_HWOUT_IDX : int : 1-based index of hardware output in P_TRACK or 0 if not a hardware output I_RECV_IDX : int : 1-based index of receive in P_DESTTRACK or 0 if not a send/receive
function reaper.GetEnvelopeInfo_Value(env, parmname) end

---@param env TrackEnvelope
---@return boolean retval, string buf
function reaper.GetEnvelopeName(env) end

---@param envelope TrackEnvelope
---@param ptidx integer
---@return boolean retval, number time, number value, integer shape, number tension, boolean selected
--- Get the attributes of an envelope point. See GetEnvelopePointEx.
function reaper.GetEnvelopePoint(envelope, ptidx) end

---@param envelope TrackEnvelope
---@param time number
---@return integer
--- Returns the envelope point at or immediately prior to the given time position. See GetEnvelopePointByTimeEx.
function reaper.GetEnvelopePointByTime(envelope, time) end

---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param time number
---@return integer
--- Returns the envelope point at or immediately prior to the given time position. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc. For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration, even if the automation item is trimmed so that not all points are visible. Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations. See GetEnvelopePointEx , SetEnvelopePointEx , InsertEnvelopePointEx , DeleteEnvelopePointEx.
function reaper.GetEnvelopePointByTimeEx(envelope, autoitem_idx, time) end

---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param ptidx integer
---@return boolean retval, number time, number value, integer shape, number tension, boolean selected
--- Get the attributes of an envelope point. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc. For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration, even if the automation item is trimmed so that not all points are visible. Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations. See CountEnvelopePointsEx , SetEnvelopePointEx , InsertEnvelopePointEx , DeleteEnvelopePointEx.
function reaper.GetEnvelopePointEx(envelope, autoitem_idx, ptidx) end

---@param env TrackEnvelope
---@return integer
--- Returns the envelope scaling mode: 0=no scaling, 1=fader scaling. All API functions deal with raw envelope point values, to convert raw from/to scaled values see ScaleFromEnvelopeMode , ScaleToEnvelopeMode.
function reaper.GetEnvelopeScalingMode(env) end

---@param env TrackEnvelope
---@param str string
---@param isundo boolean
---@return boolean retval, string str
--- Gets the RPPXML state of an envelope, returns true if successful. Undo flag is a performance/caching hint.
function reaper.GetEnvelopeStateChunk(env, str, isundo) end

---@param env TrackEnvelope
---@return integer
--- gets information on the UI state of an envelope: returns &1 if automation/modulation is playing back, &2 if automation is being actively written, &4 if the envelope recently had an effective automation mode change
function reaper.GetEnvelopeUIState(env) end

---@return string
--- returns path of REAPER.exe (not including EXE), i.e. C:\Program Files\REAPER
function reaper.GetExePath() end

---@param section string
---@param key string
---@return string
--- Get the extended state value for a specific section and key. See SetExtState , DeleteExtState , HasExtState.
function reaper.GetExtState(section, key) end

---@return integer retval, integer tracknumber, integer itemnumber, integer fxnumber
--- This function is deprecated (returns GetFocusedFX2()&3), see GetTouchedOrFocusedFX.
function reaper.GetFocusedFX() end

---@return integer retval, integer tracknumber, integer itemnumber, integer fxnumber
--- Return value has 1 set if track FX, 2 if take/item FX, 4 set if FX is no longer focused but still open. tracknumber==0 means the master track, 1 means track 1, etc. itemnumber is zero-based (or -1 if not an item). For interpretation of fxnumber, see GetLastTouchedFX . Deprecated, see GetTouchedOrFocusedFX
function reaper.GetFocusedFX2() end

---@param proj ReaProject
---@param pathidx integer
---@return integer
--- returns free disk space in megabytes, pathIdx 0 for normal, 1 for alternate.
function reaper.GetFreeDiskSpaceForRecordPath(proj, pathidx) end

---@param track MediaTrack
---@param fxindex integer
---@param parameterindex integer
---@param create boolean
---@return TrackEnvelope
--- Returns the FX parameter envelope. If the envelope does not exist and create=true, the envelope will be created. If the envelope already exists and is bypassed and create=true, then the envelope will be unbypassed.
function reaper.GetFXEnvelope(track, fxindex, parameterindex, create) end

---@return integer
--- return -1=no override, 0=trim/read, 1=read, 2=touch, 3=write, 4=latch, 5=bypass
function reaper.GetGlobalAutomationOverride() end

---@return number
--- returns pixels/second
function reaper.GetHZoomLevel() end

---@param input_id integer
---@return number
--- returns approximate input level if available, 0-511 mono inputs, |1024 for stereo pairs, 4096+devidx*32 for MIDI devices
function reaper.GetInputActivityLevel(input_id) end

---@param channelIndex integer
---@return string
function reaper.GetInputChannelName(channelIndex) end

---@return integer inputlatency, integer outputLatency
--- Gets the audio device input/output latency in samples
function reaper.GetInputOutputLatency() end

---@return number, PCM_source which_item, integer flags
--- returns time of relevant edit, set which_item to the pcm_source (if applicable), flags (if specified) will be set to 1 for edge resizing, 2 for fade change, 4 for item move, 8 for item slip edit (edit cursor time or start of item)
function reaper.GetItemEditingTime2() end

---@param screen_x integer
---@param screen_y integer
---@param allow_locked boolean
---@return MediaItem, MediaItem_Take take
--- Returns the first item at the screen coordinates specified. If allow_locked is false, locked items are ignored. If takeOutOptional specified, returns the take hit. See GetThingFromPoint.
function reaper.GetItemFromPoint(screen_x, screen_y, allow_locked) end

---@param item MediaItem
---@return ReaProject
function reaper.GetItemProjectContext(item) end

---@param item MediaItem
---@param str string
---@param isundo boolean
---@return boolean retval, string str
--- Gets the RPPXML state of an item, returns true if successful. Undo flag is a performance/caching hint.
function reaper.GetItemStateChunk(item, str, isundo) end

---@return string
function reaper.GetLastColorThemeFile() end

---@param proj ReaProject
---@param time number
---@return integer markeridx, integer regionidx
--- Get the last project marker before time, and/or the project region that includes time. markeridx and regionidx are returned not necessarily as the displayed marker/region index, but as the index that can be passed to EnumProjectMarkers. Either or both of markeridx and regionidx may be NULL. See EnumProjectMarkers.
function reaper.GetLastMarkerAndCurRegion(proj, time) end

---@return boolean retval, integer tracknumber, integer fxnumber, integer paramnumber
--- Returns true if the last touched FX parameter is valid, false otherwise. The low word of tracknumber is the 1-based track index -- 0 means the master track, 1 means track 1, etc. If the high word of tracknumber is nonzero, it refers to the 1-based item index (1 is the first item on the track, etc). For track FX, the low 24 bits of fxnumber refer to the FX index in the chain, and if the next 8 bits are 01, then the FX is record FX. For item FX, the low word defines the FX index in the chain, and the high word defines the take number. Deprecated, see GetTouchedOrFocusedFX.
function reaper.GetLastTouchedFX() end

---@return MediaTrack
function reaper.GetLastTouchedTrack() end

---@return HWND
function reaper.GetMainHwnd() end

---@return integer
--- &1=master mute,&2=master solo. This is deprecated as you can just query the master track as well.
function reaper.GetMasterMuteSoloFlags() end

---@param proj ReaProject
---@return MediaTrack
function reaper.GetMasterTrack(proj) end

---@return integer
--- returns &1 if the master track is visible in the TCP, &2 if NOT visible in the mixer. See SetMasterTrackVisibility.
function reaper.GetMasterTrackVisibility() end

---@return integer
--- returns max dev for midi inputs/outputs
function reaper.GetMaxMidiInputs() end

---@return integer
function reaper.GetMaxMidiOutputs() end

---@param mediaSource PCM_source
---@param identifier string
---@return integer retval, string buf
--- Get text-based metadata from a media file for a given identifier. Call with identifier="" to list all identifiers contained in the file, separated by newlines. May return "[Binary data]" for metadata that REAPER doesn't handle.
function reaper.GetMediaFileMetadata(mediaSource, identifier) end

---@param proj ReaProject
---@param itemidx integer
---@return MediaItem
--- get an item from a project by item count (zero-based) (proj=0 for active project)
function reaper.GetMediaItem(proj, itemidx) end

---@param item MediaItem
---@return MediaTrack
--- Get parent track of media item
function reaper.GetMediaItem_Track(item) end

---@param item MediaItem
---@param parmname string
---@return number
--- Get media item numerical-value attributes. B_MUTE : bool * : muted (item solo overrides). setting this value will clear C_MUTE_SOLO. B_MUTE_ACTUAL : bool * : muted (ignores solo). setting this value will not affect C_MUTE_SOLO. C_LANEPLAYS : char * : on fixed lane tracks, 0=this item lane does not play, 1=this item lane plays exclusively, 2=this item lane plays and other lanes also play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-lane track (read-only) C_MUTE_SOLO : char * : solo override (-1=soloed, 0=no override, 1=unsoloed). note that this API does not automatically unsolo other items when soloing (nor clear the unsolos when clearing the last soloed item), it must be done by the caller via action or via this API. B_LOOPSRC : bool * : loop source B_ALLTAKESPLAY : bool * : all takes play B_UISEL : bool * : selected in arrange view C_BEATATTACHMODE : char * : item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebase: C_BEATATTACHMODE=1, C_AUTOSTRETCH=1 C_AUTOSTRETCH: : char * : auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1 C_LOCK : char * : locked, &1=locked D_VOL : double * : item volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc D_POSITION : double * : item position in seconds D_LENGTH : double * : item length in seconds D_SNAPOFFSET : double * : item snap offset in seconds D_FADEINLEN : double * : item manual fadein length in seconds D_FADEOUTLEN : double * : item manual fadeout length in seconds D_FADEINDIR : double * : item fadein curvature, -1..1 D_FADEOUTDIR : double * : item fadeout curvature, -1..1 D_FADEINLEN_AUTO : double * : item auto-fadein length in seconds, -1=no auto-fadein D_FADEOUTLEN_AUTO : double * : item auto-fadeout length in seconds, -1=no auto-fadeout C_FADEINSHAPE : int * : fadein shape, 0..6, 0=linear C_FADEOUTSHAPE : int * : fadeout shape, 0..6, 0=linear I_GROUPID : int * : group ID, 0=no group I_LASTY : int * : Y-position (relative to top of track) in pixels (read-only) I_LASTH : int * : height in pixels (read-only) I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color I_CURTAKE : int * : active take number IP_ITEMNUMBER : int : item number on this track (read-only, returns the item number directly) F_FREEMODE_Y : float * : free item positioning or fixed lane Y-position. 0=top of track, 1.0=bottom of track F_FREEMODE_H : float * : free item positioning or fixed lane height. 0.5=half the track height, 1.0=full track height I_FIXEDLANE : int * : fixed lane of item (fine to call with setNewValue, but returned value is read-only) B_FIXEDLANE_HIDDEN : bool * : true if displaying only one fixed lane and this item is in a different lane (read-only) P_TRACK : MediaTrack * : (read-only)
function reaper.GetMediaItemInfo_Value(item, parmname) end

---@param item MediaItem
---@return integer
function reaper.GetMediaItemNumTakes(item) end

---@param item MediaItem
---@param tk integer
---@return MediaItem_Take
function reaper.GetMediaItemTake(item, tk) end

---@param take MediaItem_Take
---@return MediaItem
--- Get parent item of media item take
function reaper.GetMediaItemTake_Item(take) end

---@param take MediaItem_Take
---@param peakrate number
---@param starttime number
---@param numchannels integer
---@param numsamplesperchannel integer
---@param want_extra_type integer
---@param buf ReaperArray
---@return integer
--- Gets block of peak samples to buf. Note that the peak samples are interleaved, but in two or three blocks (maximums, then minimums, then extra). Return value has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000), then a bit to signify whether extra_type was available (0x1000000). extra_type can be 115 ('s') for spectral information, which will return peak samples as integers with the low 15 bits frequency, next 14 bits tonality.
function reaper.GetMediaItemTake_Peaks(take, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf) end

---@param take MediaItem_Take
---@return PCM_source
--- Get media source of media item take
function reaper.GetMediaItemTake_Source(take) end

---@param take MediaItem_Take
---@return MediaTrack
--- Get parent track of media item take
function reaper.GetMediaItemTake_Track(take) end

---@param project ReaProject
---@param guidGUID string
---@return MediaItem_Take
function reaper.GetMediaItemTakeByGUID(project, guidGUID) end

---@param take MediaItem_Take
---@param parmname string
---@return number
--- Get media item take numerical-value attributes. D_STARTOFFS : double * : start offset in source media, in seconds D_VOL : double * : take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped D_PAN : double * : take pan, -1..1 D_PANLAW : double * : take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc D_PLAYRATE : double * : take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc D_PITCH : double * : take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc B_PPITCH : bool * : preserve pitch when changing playback rate I_LASTY : int * : Y-position (relative to top of track) in pixels (read-only) I_LASTH : int * : height in pixels (read-only) I_CHANMODE : int * : channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right I_PITCHMODE : int * : pitch shifter mode, -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter I_STRETCHFLAGS : int * : stretch marker flags (&7 mask for mode override: 0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo) F_STRETCHFADESIZE : float * : stretch marker fade size in seconds (0.0025 default) I_RECPASSID : int * : record pass ID I_TAKEFX_NCH : int * : number of internal audio channels for per-take FX to use (OK to call with setNewValue, but the returned value is read-only) I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color IP_SPECEDIT:CNT : int : spectral edit count (read-only) IP_SPECEDIT:DELETE:x : int : read or write this key to remove the spectral edit specified IP_SPECEDIT:ADD : int : read or write this key to add a new spectral edit (returns index) IP_SPECEDIT:SORT : int : read or write this key to re-sort spectral edits (be sure to do this following a position change or insert of new edit) I_SPECEDIT:FFT_SIZE : int * : FFT size used by spectral edits for this take D_SPECEDIT:x:POSITION : double * : position of spectral edit start (changing this requires a resort of spectral edits) D_SPECEDIT:x:LENGTH : double * : length of spectral edit F_SPECEDIT:x:GAIN : float * : gain of spectral edit F_SPECEDIT:x:FADE_IN : float * : fade-in size 0..1 F_SPECEDIT:x:FADE_OUT : float * : fade-out size 0..1 F_SPECEDIT:x:FADE_LOW : float * : fade-lf size 0..1 F_SPECEDIT:x:FADE_HI : float * : fade-hf size 0..1 I_SPECEDIT:x:CHAN : int * : channel index, -1 for omni I_SPECEDIT:x:FLAGS : int * : flags, &1=bypassed, &2=solo F_SPECEDIT:x:GATE_THRESH : float * : gate threshold F_SPECEDIT:x:GATE_FLOOR : float * : gate floor F_SPECEDIT:x:COMP_THRESH : float * : comp threshold F_SPECEDIT:x:COMP_RATIO : float * : comp ratio B_SPECEDIT:x:SELECTED : bool * : selection state I_SPECEDIT:x:TOPFREQ_CNT : int * : (read-only) number of top frequency-points I_SPECEDIT:x:TOPFREQ_ADD:pos:val : int * : reading or writing will insert top frequency-point with position/value pair, returns index I_SPECEDIT:x:TOPFREQ_DEL:y : int * : reading or writing will delete top frequency-point y. there will always be at least one point. F_SPECEDIT:x:TOPFREQ_POS:y : float * : (read-only) get position of top frequency-point y F_SPECEDIT:x:TOPFREQ_FREQ:y : float * : (read-only) get frequency of top frequency-point y I_SPECEDIT:x:BOTFREQ_CNT : int * : number of bottom frequency-points I_SPECEDIT:x:BOTFREQ_ADD:pos:val : int * : reading or writing will insert bottom frequency-point with position/value pair, returns index I_SPECEDIT:x:BOTFREQ_DEL:y : int * : reading or writing will delete bottom frequency-point y. there will always be at least one point. F_SPECEDIT:x:BOTFREQ_POS:y : float * : (read-only) get position of bottom frequency-point y F_SPECEDIT:x:BOTFREQ_FREQ:y : float * : (read-only) get frequency of bottom frequency-point y IP_TAKENUMBER : int : take number (read-only, returns the take number directly) P_TRACK : pointer to MediaTrack (read-only) P_ITEM : pointer to MediaItem (read-only) P_SOURCE : PCM_source *. Note that if setting this, you should first retrieve the old source, set the new, THEN delete the old.
function reaper.GetMediaItemTakeInfo_Value(take, parmname) end

---@param item MediaItem
---@return MediaTrack
function reaper.GetMediaItemTrack(item) end

---@param source PCM_source
---@return string filenamebuf
--- Copies the media source filename to filenamebuf. Note that in-project MIDI media sources have no associated filename. See GetMediaSourceParent.
function reaper.GetMediaSourceFileName(source) end

---@param source PCM_source
---@return number retval, boolean lengthIsQN
--- Returns the length of the source media. If the media source is beat-based, the length will be in quarter notes, otherwise it will be in seconds.
function reaper.GetMediaSourceLength(source) end

---@param source PCM_source
---@return integer
--- Returns the number of channels in the source media.
function reaper.GetMediaSourceNumChannels(source) end

---@param src PCM_source
---@return PCM_source
--- Returns the parent source, or NULL if src is the root source. This can be used to retrieve the parent properties of sections or reversed sources for example.
function reaper.GetMediaSourceParent(src) end

---@param source PCM_source
---@return integer
--- Returns the sample rate. MIDI source media will return zero.
function reaper.GetMediaSourceSampleRate(source) end

---@param source PCM_source
---@return string typebuf
--- copies the media source type ("WAV", "MIDI", etc) to typebuf
function reaper.GetMediaSourceType(source) end

---@param tr MediaTrack
---@param parmname string
---@return number
--- Get track numerical-value attributes. B_MUTE : bool * : muted B_PHASE : bool * : track phase inverted B_RECMON_IN_EFFECT : bool * : record monitoring in effect (current audio-thread playback state, read-only) IP_TRACKNUMBER : int : track number 1-based, 0=not found, -1=master track (read-only, returns the int directly) I_SOLO : int * : soloed, 0=not soloed, 1=soloed, 2=soloed in place, 5=safe soloed, 6=safe soloed in place B_SOLO_DEFEAT : bool * : when set, if anything else is soloed and this track is not muted, this track acts soloed I_FXEN : int * : fx enabled, 0=bypassed, !0=fx active I_RECARM : int * : record armed, 0=not record armed, 1=record armed I_RECINPUT : int * : record input, <0=no input. if 4096 set, input is MIDI and low 5 bits represent channel (0=all, 1-16=only chan), next 6 bits represent physical input (63=all, 62=VKB). If 4096 is not set, low 10 bits (0..1023) are input start channel (ReaRoute/Loopback start at 512). If 2048 is set, input is multichannel input (using track channel count), or if 1024 is set, input is stereo input, otherwise input is mono. I_RECMODE : int * : record mode, 0=input, 1=stereo out, 2=none, 3=stereo out w/latency compensation, 4=midi output, 5=mono out, 6=mono out w/ latency compensation, 7=midi overdub, 8=midi replace I_RECMODE_FLAGS : int * : record mode flags, &3=output recording mode (0=post fader, 1=pre-fx, 2=post-fx/pre-fader) I_RECMON : int * : record monitoring, 0=off, 1=normal, 2=not when playing (tape style) I_RECMONITEMS : int * : monitor items while recording, 0=off, 1=on B_AUTO_RECARM : bool * : automatically set record arm when selected (does not immediately affect recarm state, script should set directly if desired) I_VUMODE : int * : track vu mode, &1:disabled, &30==0:stereo peaks, &30==2:multichannel peaks, &30==4:stereo RMS, &30==8:combined RMS, &30==12:LUFS-M, &30==16:LUFS-S (readout=max), &30==20:LUFS-S (readout=current), &32:LUFS calculation on channels 1+2 only I_AUTOMODE : int * : track automation mode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch I_NCHAN : int * : number of track channels, 2-128, even numbers only I_SELECTED : int * : track selected, 0=unselected, 1=selected I_WNDH : int * : current TCP window height in pixels including envelopes (read-only) I_TCPH : int * : current TCP window height in pixels not including envelopes (read-only) I_TCPY : int * : current TCP window Y-position in pixels relative to top of arrange view (read-only) I_MCPX : int * : current MCP X-position in pixels relative to mixer container (read-only) I_MCPY : int * : current MCP Y-position in pixels relative to mixer container (read-only) I_MCPW : int * : current MCP width in pixels (read-only) I_MCPH : int * : current MCP height in pixels (read-only) I_FOLDERDEPTH : int * : folder depth change, 0=normal, 1=track is a folder parent, -1=track is the last in the innermost folder, -2=track is the last in the innermost and next-innermost folders, etc I_FOLDERCOMPACT : int * : folder collapsed state (only valid on folders), 0=normal, 1=collapsed, 2=fully collapsed I_MIDIHWOUT : int * : track midi hardware output index, <0=disabled, low 5 bits are which channels (0=all, 1-16), next 5 bits are output device index (0-31) I_MIDI_INPUT_CHANMAP : int * : -1 maps to source channel, otherwise 1-16 to map to MIDI channel I_MIDI_CTL_CHAN : int * : -1 no link, 0-15 link to MIDI volume/pan on channel, 16 link to MIDI volume/pan on all channels I_MIDI_TRACKSEL_FLAG : int * : MIDI editor track list options: &1=expand media items, &2=exclude from list, &4=auto-pruned I_PERFFLAGS : int * : track performance flags, &1=no media buffering, &2=no anticipative FX I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color I_HEIGHTOVERRIDE : int * : custom height override for TCP window, 0 for none, otherwise size in pixels I_SPACER : int * : 1=TCP track spacer above this trackB_HEIGHTLOCK : bool * : track height lock (must set I_HEIGHTOVERRIDE before locking) D_VOL : double * : trim volume of track, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc D_PAN : double * : trim pan of track, -1..1 D_WIDTH : double * : width of track, -1..1 D_DUALPANL : double * : dualpan position 1, -1..1, only if I_PANMODE==6 D_DUALPANR : double * : dualpan position 2, -1..1, only if I_PANMODE==6 I_PANMODE : int * : pan mode, 0=classic 3.x, 3=new balance, 5=stereo pan, 6=dual pan D_PANLAW : double * : pan law of track, <0=project default, 0.5=-6dB, 0.707..=-3dB, 1=+0dB, 1.414..=-3dB with gain compensation, 2=-6dB with gain compensation, etc I_PANLAW_FLAGS : int * : pan law flags, 0=sine taper, 1=hybrid taper with deprecated behavior when gain compensation enabled, 2=linear taper, 3=hybrid taper P_ENV:<envchunkname or P_ENV:{GUID... : TrackEnvelope * : (read-only) chunkname can be <VOLENV, <PANENV, etc; GUID is the stringified envelope GUID. B_SHOWINMIXER : bool * : track control panel visible in mixer (do not use on master track) B_SHOWINTCP : bool * : track control panel visible in arrange view (do not use on master track) B_MAINSEND : bool * : track sends audio to parent C_MAINSEND_OFFS : char * : channel offset of track send to parent C_MAINSEND_NCH : char * : channel count of track send to parent (0=use all child track channels, 1=use one channel only) I_FREEMODE : int * : 1=track free item positioning enabled, 2=track fixed lanes enabled (call UpdateTimeline() after changing) I_NUMFIXEDLANES : int * : number of track fixed lanes (fine to call with setNewValue, but returned value is read-only) C_LANESCOLLAPSED : char * : fixed lane collapse state (1=lanes collapsed, 2=track displays as non-fixed-lanes but hidden lanes exist) C_LANESETTINGS : char * : fixed lane settings (&1=auto-remove empty lanes at bottom, &2=do not auto-comp new recording, &4=newly recorded lanes play exclusively (else add lanes in layers), &8=big lanes (else small lanes), &16=add new recording at bottom (else record into first available lane), &32=hide lane buttons C_LANEPLAYS:N : char * : on fixed lane tracks, 0=lane N does not play, 1=lane N plays exclusively, 2=lane N plays and other lanes also play (fine to call with setNewValue, but returned value is read-only) C_ALLLANESPLAY : char * : on fixed lane tracks, 0=no lanes play, 1=all lanes play, 2=some lanes play (fine to call with setNewValue 0 or 1, but returned value is read-only) C_BEATATTACHMODE : char * : track timebase, -1=project default, 0=time, 1=beats (position, length, rate), 2=beats (position only) F_MCP_FXSEND_SCALE : float * : scale of fx+send area in MCP (0=minimum allowed, 1=maximum allowed) F_MCP_FXPARM_SCALE : float * : scale of fx parameter area in MCP (0=minimum allowed, 1=maximum allowed) F_MCP_SENDRGN_SCALE : float * : scale of send area as proportion of the fx+send total area (0=minimum allowed, 1=maximum allowed) F_TCP_FXPARM_SCALE : float * : scale of TCP parameter area when TCP FX are embedded (0=min allowed, default, 1=max allowed) I_PLAY_OFFSET_FLAG : int * : track media playback offset state, &1=bypassed, &2=offset value is measured in samples (otherwise measured in seconds) D_PLAY_OFFSET : double * : track media playback offset, units depend on I_PLAY_OFFSET_FLAG P_PARTRACK : MediaTrack * : parent track (read-only) P_PROJECT : ReaProject * : parent project (read-only)
function reaper.GetMediaTrackInfo_Value(tr, parmname) end

---@param dev integer
---@param nameout string
---@return boolean retval, string nameout
--- returns true if device present
function reaper.GetMIDIInputName(dev, nameout) end

---@param dev integer
---@param nameout string
---@return boolean retval, string nameout
--- returns true if device present
function reaper.GetMIDIOutputName(dev, nameout) end

---@return MediaTrack
--- Get the leftmost track visible in the mixer
function reaper.GetMixerScroll() end

---@param context string
---@param modifier_flag integer
---@return string action
--- Get the current mouse modifier assignment for a specific modifier key assignment, in a specific context. action will be filled in with the command ID number for a built-in mouse modifier or built-in REAPER command ID, or the custom action ID string. Note: the action string may have a space and 'c' or 'm' appended to it to specify command ID vs mouse modifier ID. See SetMouseModifier for more information.
function reaper.GetMouseModifier(context, modifier_flag) end

---@return integer x, integer y
--- get mouse position in screen coordinates
function reaper.GetMousePosition() end

---@return integer
--- Return number of normal audio hardware inputs available
function reaper.GetNumAudioInputs() end

---@return integer
--- Return number of normal audio hardware outputs available
function reaper.GetNumAudioOutputs() end

---@return integer
--- returns max number of real midi hardware inputs
function reaper.GetNumMIDIInputs() end

---@return integer
--- returns max number of real midi hardware outputs
function reaper.GetNumMIDIOutputs() end

---@param take MediaItem_Take
---@return integer
--- Returns number of take markers. See GetTakeMarker , SetTakeMarker , DeleteTakeMarker
function reaper.GetNumTakeMarkers(take) end

---@return integer
--- Returns number of tracks in current project, see CountTracks ()
function reaper.GetNumTracks() end

---@return string
--- Returns "Win32", "Win64", "OSX32", "OSX64", "macOS-arm64", or "Other".
function reaper.GetOS() end

---@param channelIndex integer
---@return string
function reaper.GetOutputChannelName(channelIndex) end

---@return number
--- returns output latency in seconds
function reaper.GetOutputLatency() end

---@param track MediaTrack
---@return MediaTrack
function reaper.GetParentTrack(track) end

---@param fn string
---@return string buf
--- get the peak file name for a given file (can be either filename.reapeaks,or a hashed filename in another path)
function reaper.GetPeakFileName(fn) end

---@param fn string
---@param buf string
---@param forWrite boolean
---@return string buf
--- get the peak file name for a given file (can be either filename.reapeaks,or a hashed filename in another path)
function reaper.GetPeakFileNameEx(fn, buf, forWrite) end

---@param fn string
---@param buf string
---@param forWrite boolean
---@param peaksfileextension string
---@return string buf
--- Like GetPeakFileNameEx, but you can specify peaksfileextension such as ".reapeaks"
function reaper.GetPeakFileNameEx2(fn, buf, forWrite, peaksfileextension) end

---@return number
--- returns latency-compensated actual-what-you-hear position
function reaper.GetPlayPosition() end

---@return number
--- returns position of next audio block being processed
function reaper.GetPlayPosition2() end

---@param proj ReaProject
---@return number
--- returns position of next audio block being processed
function reaper.GetPlayPosition2Ex(proj) end

---@param proj ReaProject
---@return number
--- returns latency-compensated actual-what-you-hear position
function reaper.GetPlayPositionEx(proj) end

---@return integer
--- &1=playing, &2=paused, &4=is recording
function reaper.GetPlayState() end

---@param proj ReaProject
---@return integer
--- &1=playing, &2=paused, &4=is recording
function reaper.GetPlayStateEx(proj) end

---@param proj ReaProject
---@return number
--- returns length of project (maximum of end of media item, markers, end of regions, tempo map
function reaper.GetProjectLength(proj) end

---@param proj ReaProject
---@return string buf
function reaper.GetProjectName(proj) end

---@return string buf
--- Get the project recording path.
function reaper.GetProjectPath() end

---@param proj ReaProject
---@return string buf
--- Get the project recording path.
function reaper.GetProjectPathEx(proj) end

---@param proj ReaProject
---@return integer
--- returns an integer that changes when the project state changes
function reaper.GetProjectStateChangeCount(proj) end

---@param proj ReaProject
---@param rndframe boolean
---@return number
--- Gets project time offset in seconds (project settings - project start time). If rndframe is true, the offset is rounded to a multiple of the project frame size.
function reaper.GetProjectTimeOffset(proj, rndframe) end

---@return number bpm, number bpi
--- deprecated
function reaper.GetProjectTimeSignature() end

---@param proj ReaProject
---@return number bpm, number bpi
--- Gets basic time signature (beats per minute, numerator of time signature in bpi) this does not reflect tempo envelopes but is purely what is set in the project settings.
function reaper.GetProjectTimeSignature2(proj) end

---@param proj ReaProject
---@param extname string
---@param key string
---@return integer retval, string val
--- Get the value previously associated with this extname and key, the last time the project was saved. See SetProjExtState , EnumProjExtState.
function reaper.GetProjExtState(proj, extname, key) end

---@return string
--- returns path where ini files are stored, other things are in subdirectories.
function reaper.GetResourcePath() end

---@param proj ReaProject
---@return TrackEnvelope
--- get the currently selected envelope, returns NULL/nil if no envelope is selected
function reaper.GetSelectedEnvelope(proj) end

---@param proj ReaProject
---@param selitem integer
---@return MediaItem
--- Discouraged, because GetSelectedMediaItem can be inefficient if media items are added, rearranged, or deleted in between calls. Instead see CountMediaItems , GetMediaItem , IsMediaItemSelected.
function reaper.GetSelectedMediaItem(proj, selitem) end

---@param proj ReaProject
---@param seltrackidx integer
---@return MediaTrack
--- Get a selected track from a project (proj=0 for active project) by selected track count (zero-based). This function ignores the master track, see GetSelectedTrack2.
function reaper.GetSelectedTrack(proj, seltrackidx) end

---@param proj ReaProject
---@param seltrackidx integer
---@param wantmaster boolean
---@return MediaTrack
--- Get a selected track from a project (proj=0 for active project) by selected track count (zero-based).
function reaper.GetSelectedTrack2(proj, seltrackidx, wantmaster) end

---@param proj ReaProject
---@return TrackEnvelope
--- get the currently selected track envelope, returns NULL/nil if no envelope is selected
function reaper.GetSelectedTrackEnvelope(proj) end

---@param proj ReaProject
---@param isSet boolean
---@param screen_x_start integer
---@param screen_x_end integer
---@param start_time number
---@param end_time number
---@return number start_time, number end_time
--- Gets or sets the arrange view start/end time for screen coordinates. use screen_x_start=screen_x_end=0 to use the full arrange view's start/end time
function reaper.GetSet_ArrangeView2(proj, isSet, screen_x_start, screen_x_end, start_time, end_time) end

---@param isSet boolean
---@param isLoop boolean
---@param start number
---@param end_ number
---@param allowautoseek boolean
---@return number start, number end
function reaper.GetSet_LoopTimeRange(isSet, isLoop, start, end_, allowautoseek) end

---@param proj ReaProject
---@param isSet boolean
---@param isLoop boolean
---@param start number
---@param end_ number
---@param allowautoseek boolean
---@return number start, number end
function reaper.GetSet_LoopTimeRange2(proj, isSet, isLoop, start, end_, allowautoseek) end

---@param env TrackEnvelope
---@param autoitem_idx integer
---@param desc string
---@param value number
---@param is_set boolean
---@return number
--- Get or set automation item information. autoitem_idx=0 for the first automation item on an envelope, 1 for the second item, etc. desc can be any of the following: D_POOL_ID : double * : automation item pool ID (as an integer); edits are propagated to all other automation items that share a pool ID D_POSITION : double * : automation item timeline position in seconds D_LENGTH : double * : automation item length in seconds D_STARTOFFS : double * : automation item start offset in seconds D_PLAYRATE : double * : automation item playback rate D_BASELINE : double * : automation item baseline value in the range [0,1] D_AMPLITUDE : double * : automation item amplitude in the range [-1,1] D_LOOPSRC : double * : nonzero if the automation item contents are looped D_UISEL : double * : nonzero if the automation item is selected in the arrange view D_POOL_QNLEN : double * : automation item pooled source length in quarter notes (setting will affect all pooled instances)
function reaper.GetSetAutomationItemInfo(env, autoitem_idx, desc, value, is_set) end

---@param env TrackEnvelope
---@param autoitem_idx integer
---@param desc string
---@param valuestrNeedBig string
---@param is_set boolean
---@return boolean retval, string valuestrNeedBig
--- Get or set automation item information. autoitem_idx=0 for the first automation item on an envelope, 1 for the second item, etc. returns true on success. desc can be any of the following: P_POOL_NAME : char * : name of the underlying automation item pool P_POOL_EXT:xyz : char * : extension-specific persistent data
function reaper.GetSetAutomationItemInfo_String(env, autoitem_idx, desc, valuestrNeedBig, is_set) end

---@param env TrackEnvelope
---@param parmname string
---@param stringNeedBig string
---@param setNewValue boolean
---@return boolean retval, string stringNeedBig
--- Gets/sets an attribute string: ACTIVE : active state (bool as a string "0" or "1") ARM : armed state (bool...) VISIBLE : visible state (bool...) SHOWLANE : show envelope in separate lane (bool...) GUID : (read-only) GUID as a string {xyz-....} P_EXT:xyz : extension-specific persistent data Note that when writing some of these attributes you will need to manually update the arrange and/or track panels, see TrackList_AdjustWindows
function reaper.GetSetEnvelopeInfo_String(env, parmname, stringNeedBig, setNewValue) end

---@param env TrackEnvelope
---@param str string
---@return boolean retval, string str
--- deprecated -- see SetEnvelopeStateChunk , GetEnvelopeStateChunk
function reaper.GetSetEnvelopeState(env, str) end

---@param env TrackEnvelope
---@param str string
---@param isundo boolean
---@return boolean retval, string str
--- deprecated -- see SetEnvelopeStateChunk , GetEnvelopeStateChunk
function reaper.GetSetEnvelopeState2(env, str, isundo) end

---@param item MediaItem
---@param str string
---@return boolean retval, string str
--- deprecated -- see SetItemStateChunk , GetItemStateChunk
function reaper.GetSetItemState(item, str) end

---@param item MediaItem
---@param str string
---@param isundo boolean
---@return boolean retval, string str
--- deprecated -- see SetItemStateChunk , GetItemStateChunk
function reaper.GetSetItemState2(item, str, isundo) end

---@param item MediaItem
---@param parmname string
---@param stringNeedBig string
---@param setNewValue boolean
---@return boolean retval, string stringNeedBig
--- Gets/sets an item attribute string: P_NOTES : char * : item note text (do not write to returned pointer, use setNewValue to update) P_EXT:xyz : char * : extension-specific persistent data GUID : GUID * : 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
function reaper.GetSetMediaItemInfo_String(item, parmname, stringNeedBig, setNewValue) end

---@param tk MediaItem_Take
---@param parmname string
---@param stringNeedBig string
---@param setNewValue boolean
---@return boolean retval, string stringNeedBig
--- Gets/sets a take attribute string: P_NAME : char * : take name P_EXT:xyz : char * : extension-specific persistent data GUID : GUID * : 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
function reaper.GetSetMediaItemTakeInfo_String(tk, parmname, stringNeedBig, setNewValue) end

---@param tr MediaTrack
---@param parmname string
---@param stringNeedBig string
---@param setNewValue boolean
---@return boolean retval, string stringNeedBig
--- Get or set track string attributes. P_NAME : char * : track name (on master returns NULL) P_ICON : const char * : track icon (full filename, or relative to resource_path/data/track_icons) P_LANENAME:n : char * : lane name (returns NULL for non-fixed-lane-tracks) P_MCP_LAYOUT : const char * : layout name P_RAZOREDITS : const char * : list of razor edit areas, as space-separated triples of start time, end time, and envelope GUID string. Example: "0.0 1.0 \"\" 0.0 1.0 "{xyz-...}" P_RAZOREDITS_EXT : const char * : list of razor edit areas, as comma-separated sets of space-separated tuples of start time, end time, optional: envelope GUID string, fixed/fipm top y-position, fixed/fipm bottom y-position. Example: "0.0 1.0,0.0 1.0 "{xyz-...}",1.0 2.0 "" 0.25 0.75" P_TCP_LAYOUT : const char * : layout name P_EXT:xyz : char * : extension-specific persistent data P_UI_RECT:tcp.mute : char * : read-only, allows querying screen position + size of track WALTER elements (tcp.size queries screen position and size of entire TCP, etc). GUID : GUID * : 16-byte GUID, can query or update. If using a _String() function, GUID is a string {xyz-...}.
function reaper.GetSetMediaTrackInfo_String(tr, parmname, stringNeedBig, setNewValue) end

---@param proj ReaProject
---@param set boolean
---@param author string
---@return string author
--- deprecated, see GetSetProjectInfo_String with desc="PROJECT_AUTHOR"
function reaper.GetSetProjectAuthor(proj, set, author) end

---@param project ReaProject
---@param set boolean
---@param division optional number
---@param swingmode optional integer
---@param swingamt optional number
---@return integer retval, number division, integer swingmode, number swingamt
--- Get or set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note triplet, etc. swingmode can be 1 for swing enabled, swingamt is -1..1. swingmode can be 3 for measure-grid. Returns grid configuration flags
function reaper.GetSetProjectGrid(project, set, division, swingmode, swingamt) end

---@param project ReaProject
---@param desc string
---@param value number
---@param is_set boolean
---@return number
--- Get or set project information. RENDER_SETTINGS : &(1|2)=0:master mix, &1=stems+master mix, &2=stems only, &4=multichannel tracks to multichannel files, &8=use render matrix, &16=tracks with only mono media to mono files, &32=selected media items, &64=selected media items via master, &128=selected tracks via master, &256=embed transients if format supports, &512=embed metadata if format supports, &1024=embed take markers if format supports, &2048=2nd pass render RENDER_BOUNDSFLAG : 0=custom time bounds, 1=entire project, 2=time selection, 3=all project regions, 4=selected media items, 5=selected project regions, 6=all project markers, 7=selected project markers RENDER_CHANNELS : number of channels in rendered file RENDER_SRATE : sample rate of rendered file (or 0 for project sample rate) RENDER_STARTPOS : render start time when RENDER_BOUNDSFLAG=0 RENDER_ENDPOS : render end time when RENDER_BOUNDSFLAG=0 RENDER_TAILFLAG : apply render tail setting when rendering: &1=custom time bounds, &2=entire project, &4=time selection, &8=all project markers/regions, &16=selected media items, &32=selected project markers/regions RENDER_TAILMS : tail length in ms to render (only used if RENDER_BOUNDSFLAG and RENDER_TAILFLAG are set) RENDER_ADDTOPROJ : &1=add rendered files to project, &2=do not render files that are likely silent RENDER_DITHER : &1=dither, &2=noise shaping, &4=dither stems, &8=noise shaping on stems RENDER_NORMALIZE: &1=enable, (&14==0)=LUFS-I, (&14==2)=RMS, (&14==4)=peak, (&14==6)=true peak, (&14==8)=LUFS-M max, (&14==10)=LUFS-S max, &16=adjust mono media -3dB, &(16|(8<<16))=adjust mono media +3dB, (&(32|4096)==32)=normalize stems as if files play together (common gain), (&(32|4096)==4096)=normalize to loudest file, (&(32|4096)==(32|4096))=normalize as if files play together (common gain)&64=enable brickwall limit, &128=brickwall limit true peak, (&(256|2048)==256)=only normalize files that are too loud, (&(256|2048)==2048)=only normalize files that are too quiet, &512=apply fade-in, &1024=apply fade-out, &16384=trim starting silence, &32768=trim ending silence, &(1<<16)=pad start with silence, &(2<<16)=pad end with silence, &(4<<16)=disable all render postprocessing, &(32<<16)=limit as if files play together RENDER_NORMALIZE_TARGET: render normalization target (0.5 means -6.02dB, requires RENDER_NORMALIZE&1) RENDER_BRICKWALL: render brickwall limit (0.5 means -6.02dB, requires RENDER_NORMALIZE&64) RENDER_FADEIN: render fade-in (0.001 means 1 ms, requires RENDER_NORMALIZE&512) RENDER_FADEOUT: render fade-out (0.001 means 1 ms, requires RENDER_NORMALIZE&1024) RENDER_FADEINSHAPE: render fade-in shape RENDER_FADEOUTSHAPE: render fade-out shape RENDER_PADSTART: pad render start with silence (0.001 means 1ms, requires RENDER_NORMALIZE&(1<<16)) RENDER_PADEND: pad render end with silence (0.001 means 1ms, requires RENDER_NORMALIZE&(2<<16)) RENDER_TRIMSTART: trim render start threshold (0.5 means -6.02dB, requires RENDER_NORMALIZE&16384) RENDER_TRIMEND: trim render end threshold (0.5 means -6.02dB, requires RENDER_NORMALIZE&32768) PROJECT_SRATE : sample rate (ignored unless PROJECT_SRATE_USE set) PROJECT_SRATE_USE : set to 1 if project sample rate is used
function reaper.GetSetProjectInfo(project, desc, value, is_set) end

---@param project ReaProject
---@param desc string
---@param valuestrNeedBig string
---@param is_set boolean
---@return boolean retval, string valuestrNeedBig
--- Get or set project information. PROJECT_NAME : project file name (read-only, is_set will be ignored) PROJECT_TITLE : title field from Project Settings/Notes dialog PROJECT_AUTHOR : author field from Project Settings/Notes dialog TRACK_GROUP_NAME:X : track group name, X should be 1..64 MARKER_GUID:X : get the GUID (unique ID) of the marker or region with index X, where X is the index passed to EnumProjectMarkers, not necessarily the displayed number (read-only) MARKER_INDEX_FROM_GUID:{GUID} : get the GUID index of the marker or region with GUID {GUID} (read-only) OPENCOPY_CFGIDX : integer for the configuration of format to use when creating copies/applying FX. 0=wave (auto-depth), 1=APPLYFX_FORMAT, 2=RECORD_FORMAT RECORD_PATH : recording directory -- may be blank or a relative path, to get the effective path see GetProjectPathEx () RECORD_PATH_SECONDARY : secondary recording directory RECORD_FORMAT : base64-encoded sink configuration (see project files, etc). Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type. APPLYFX_FORMAT : base64-encoded sink configuration (see project files, etc). Used only if RECFMT_OPENCOPY is set to 1. Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type. RECTAG : project recording tag wildcard ($rectag). Can be used in Preferences/Audio/Recording to auto-name recorded files. RENDER_FILE : render directory RENDER_PATTERN : render file name (may contain wildcards) RENDER_METADATA : get or set the metadata saved with the project (not metadata embedded in project media). Example, ID3 album name metadata: valuestr="ID3:TALB" to get, valuestr="ID3:TALB|my album name" to set. Call with valuestr="" and is_set=false to get a semicolon-separated list of defined project metadata identifiers. RENDER_TARGETS : semicolon separated list of files that would be written if the project is rendered using the most recent render settings RENDER_STATS : (read-only) semicolon separated list of statistics for the most recently rendered files. call with valuestr="XXX" to run an action (for example, "42437"=dry run render selected items) before returning statistics. RENDER_FORMAT : base64-encoded sink configuration (see project files, etc). Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type. RENDER_FORMAT2 : base64-encoded secondary sink configuration. Callers can also pass a simple 4-byte string (non-base64-encoded), e.g. "evaw" or "l3pm", to use default settings for that sink type, or "" to disable secondary render. Formats available on this machine: "wave" "aiff" "caff"
function reaper.GetSetProjectInfo_String(project, desc, valuestrNeedBig, is_set) end

---@param proj ReaProject
---@param set boolean
---@param notes string
---@return string notes
--- gets or sets project notes, notesNeedBig_sz is ignored when setting
function reaper.GetSetProjectNotes(proj, set, notes) end

---@param val integer
---@return integer
--- -1 == query,0=clear,1=set,>1=toggle . returns new value
function reaper.GetSetRepeat(val) end

---@param proj ReaProject
---@param val integer
---@return integer
--- -1 == query,0=clear,1=set,>1=toggle . returns new value
function reaper.GetSetRepeatEx(proj, val) end

---@param project ReaProject
---@param point_index integer
---@param flag integer
---@param is_set boolean
---@return integer
--- Gets or sets the attribute flag of a tempo/time signature marker. flag &1=sets time signature and starts new measure, &2=does not set tempo, &4=allow previous partial measure if starting new measure, &8=set new metronome pattern if starting new measure, &16=reset ruler grid if starting new measure
function reaper.GetSetTempoTimeSigMarkerFlag(project, point_index, flag, is_set) end

---@param tr MediaTrack
---@param groupname string
---@param setmask integer
---@param setvalue integer
---@return integer
--- Gets or modifies the group membership for a track. Returns group state prior to call (each bit represents one of the 32 group numbers). if setmask has bits set, those bits in setvalue will be applied to group. Group can be one of: MEDIA_EDIT_LEAD MEDIA_EDIT_FOLLOW VOLUME_LEAD VOLUME_FOLLOW VOLUME_VCA_LEAD VOLUME_VCA_FOLLOW PAN_LEAD PAN_FOLLOW WIDTH_LEAD WIDTH_FOLLOW MUTE_LEAD MUTE_FOLLOW SOLO_LEAD SOLO_FOLLOW RECARM_LEAD RECARM_FOLLOW POLARITY_LEAD POLARITY_FOLLOW AUTOMODE_LEAD AUTOMODE_FOLLOW VOLUME_REVERSE PAN_REVERSE WIDTH_REVERSE NO_LEAD_WHEN_FOLLOW VOLUME_VCA_FOLLOW_ISPREFX Note: REAPER v6.11 and earlier used _MASTER and _SLAVE rather than _LEAD and _FOLLOW, which is deprecated but still supported (scripts that must support v6.11 and earlier can use the deprecated strings).
function reaper.GetSetTrackGroupMembership(tr, groupname, setmask, setvalue) end

---@param tr MediaTrack
---@param groupname string
---@param offset integer
---@param setmask integer
---@param setvalue integer
---@return integer
--- Gets or modifies 32 bits (at offset, where 0 is the low 32 bits of the grouping) of the group membership for a track. Returns group state prior to call. if setmask has bits set, those bits in setvalue will be applied to group. Group can be one of: MEDIA_EDIT_LEAD MEDIA_EDIT_FOLLOW VOLUME_LEAD VOLUME_FOLLOW VOLUME_VCA_LEAD VOLUME_VCA_FOLLOW PAN_LEAD PAN_FOLLOW WIDTH_LEAD WIDTH_FOLLOW MUTE_LEAD MUTE_FOLLOW SOLO_LEAD SOLO_FOLLOW RECARM_LEAD RECARM_FOLLOW POLARITY_LEAD POLARITY_FOLLOW AUTOMODE_LEAD AUTOMODE_FOLLOW VOLUME_REVERSE PAN_REVERSE WIDTH_REVERSE NO_LEAD_WHEN_FOLLOW VOLUME_VCA_FOLLOW_ISPREFX Note: REAPER v6.11 and earlier used _MASTER and _SLAVE rather than _LEAD and _FOLLOW, which is deprecated but still supported (scripts that must support v6.11 and earlier can use the deprecated strings).
function reaper.GetSetTrackGroupMembershipEx(tr, groupname, offset, setmask, setvalue) end

---@param tr MediaTrack
---@param groupname string
---@param setmask integer
---@param setvalue integer
---@return integer
--- Gets or modifies the group membership for a track. Returns group state prior to call (each bit represents one of the high 32 group numbers). if setmask has bits set, those bits in setvalue will be applied to group. Group can be one of: MEDIA_EDIT_LEAD MEDIA_EDIT_FOLLOW VOLUME_LEAD VOLUME_FOLLOW VOLUME_VCA_LEAD VOLUME_VCA_FOLLOW PAN_LEAD PAN_FOLLOW WIDTH_LEAD WIDTH_FOLLOW MUTE_LEAD MUTE_FOLLOW SOLO_LEAD SOLO_FOLLOW RECARM_LEAD RECARM_FOLLOW POLARITY_LEAD POLARITY_FOLLOW AUTOMODE_LEAD AUTOMODE_FOLLOW VOLUME_REVERSE PAN_REVERSE WIDTH_REVERSE NO_LEAD_WHEN_FOLLOW VOLUME_VCA_FOLLOW_ISPREFX Note: REAPER v6.11 and earlier used _MASTER and _SLAVE rather than _LEAD and _FOLLOW, which is deprecated but still supported (scripts that must support v6.11 and earlier can use the deprecated strings).
function reaper.GetSetTrackGroupMembershipHigh(tr, groupname, setmask, setvalue) end

---@param tr MediaTrack
---@param category integer
---@param sendidx integer
---@param parmname string
---@param stringNeedBig string
---@param setNewValue boolean
---@return boolean retval, string stringNeedBig
--- Gets/sets a send attribute string: P_EXT:xyz : char * : extension-specific persistent data
function reaper.GetSetTrackSendInfo_String(tr, category, sendidx, parmname, stringNeedBig, setNewValue) end

---@param track MediaTrack
---@param str string
---@return boolean retval, string str
--- deprecated -- see SetTrackStateChunk , GetTrackStateChunk
function reaper.GetSetTrackState(track, str) end

---@param track MediaTrack
---@param str string
---@param isundo boolean
---@return boolean retval, string str
--- deprecated -- see SetTrackStateChunk , GetTrackStateChunk
function reaper.GetSetTrackState2(track, str, isundo) end

---@param src PCM_source
---@return ReaProject
function reaper.GetSubProjectFromSource(src) end

---@param item MediaItem
---@param takeidx integer
---@return MediaItem_Take
--- get a take from an item by take count (zero-based)
function reaper.GetTake(item, takeidx) end

---@param take MediaItem_Take
---@param envidx integer
---@return TrackEnvelope
function reaper.GetTakeEnvelope(take, envidx) end

---@param take MediaItem_Take
---@param envname string
---@return TrackEnvelope
function reaper.GetTakeEnvelopeByName(take, envname) end

---@param take MediaItem_Take
---@param idx integer
---@return number retval, string name, integer color
--- Get information about a take marker. Returns the position in media item source time, or -1 if the take marker does not exist. See GetNumTakeMarkers , SetTakeMarker , DeleteTakeMarker
function reaper.GetTakeMarker(take, idx) end

---@param take MediaItem_Take
---@return string
--- returns NULL if the take is not valid
function reaper.GetTakeName(take) end

---@param take MediaItem_Take
---@return integer
--- Returns number of stretch markers in take
function reaper.GetTakeNumStretchMarkers(take) end

---@param take MediaItem_Take
---@param idx integer
---@return integer retval, number pos, number srcpos
--- Gets information on a stretch marker, idx is 0..n. Returns -1 if stretch marker not valid. posOut will be set to position in item, srcposOutOptional will be set to source media position. Returns index. if input index is -1, the following marker is found using position (or source position if position is -1). If position/source position are used to find marker position, their values are not updated.
function reaper.GetTakeStretchMarker(take, idx) end

---@param take MediaItem_Take
---@param idx integer
---@return number
--- See SetTakeStretchMarkerSlope
function reaper.GetTakeStretchMarkerSlope(take, idx) end

---@param project ReaProject
---@param track MediaTrack
---@param index integer
---@return boolean retval, integer fxindex, integer parmidx
--- Get information about a specific FX parameter knob (see CountTCPFXParms ).
function reaper.GetTCPFXParm(project, track, index) end

---@param source PCM_source
---@param srcscale number
---@param position number
---@param mult number
---@return boolean retval, number rate, number targetlen
--- finds the playrate and target length to insert this item stretched to a round power-of-2 number of bars, between 1/8 and 256
function reaper.GetTempoMatchPlayRate(source, srcscale, position, mult) end

---@param proj ReaProject
---@param ptidx integer
---@return boolean retval, number timepos, integer measurepos, number beatpos, number bpm, integer timesig_num, integer timesig_denom, boolean lineartempo
--- Get information about a tempo/time signature marker. See CountTempoTimeSigMarkers , SetTempoTimeSigMarker , AddTempoTimeSigMarker.
function reaper.GetTempoTimeSigMarker(proj, ptidx) end

---@param ini_key string
---@param flags integer
---@return integer
--- Returns the theme color specified, or -1 on failure. If the low bit of flags is set, the color as originally specified by the theme (before any transformations) is returned, otherwise the current (possibly transformed and modified) color is returned. See SetThemeColor for a list of valid ini_key.
function reaper.GetThemeColor(ini_key, flags) end

---@param screen_x integer
---@param screen_y integer
---@return MediaTrack retval, string info
--- Hit tests a point in screen coordinates. Updates infoOut with information such as "arrange", "fx_chain", "fx_0" (first FX in chain, floating), "spacer_0" (spacer before first track). If a track panel is hit, string will begin with "tcp" or "mcp" or "tcp.mute" etc (future versions may append additional information). May return NULL with valid info string to indicate non-track thing.
function reaper.GetThingFromPoint(screen_x, screen_y) end

---@param command_id integer
---@return integer
--- See GetToggleCommandStateEx.
function reaper.GetToggleCommandState(command_id) end

---@param section_id integer
---@param command_id integer
---@return integer
--- For the main action context, the MIDI editor, or the media explorer, returns the toggle state of the action. 0=off, 1=on, -1=NA because the action does not have on/off states. For the MIDI editor, the action state for the most recently focused window will be returned.
function reaper.GetToggleCommandStateEx(section_id, command_id) end

---@return HWND
--- gets a tooltip window,in case you want to ask it for font information. Can return NULL.
function reaper.GetTooltipWindow() end

---@param mode integer
---@return boolean retval, integer trackidx, integer itemidx, integer takeidx, integer fxidx, integer parm
--- mode can be 0 to query last touched parameter, or 1 to query currently focused FX. Returns false if failed. If successful, trackIdxOut will be track index (-1 is master track, 0 is first track). itemidxOut will be 0-based item index if an item, or -1 if not an item. takeidxOut will be 0-based take index. fxidxOut will be FX index, potentially with 0x2000000 set to signify container-addressing, or with 0x1000000 set to signify record-input FX. parmOut will be set to the parameter index if querying last-touched. parmOut will have 1 set if querying focused state and FX is no longer focused but still open.
function reaper.GetTouchedOrFocusedFX(mode) end

---@param proj ReaProject
---@param trackidx integer
---@return MediaTrack
--- get a track from a project by track count (zero-based) (proj=0 for active project)
function reaper.GetTrack(proj, trackidx) end

---@param tr MediaTrack
---@return integer
--- return the track mode, regardless of global override
function reaper.GetTrackAutomationMode(tr) end

---@param track MediaTrack
---@return integer
--- Returns the track custom color as OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). Black is returned as 0x1000000, no color setting is returned as 0.
function reaper.GetTrackColor(track) end

---@param track MediaTrack
---@return integer
function reaper.GetTrackDepth(track) end

---@param track MediaTrack
---@param envidx integer
---@return TrackEnvelope
function reaper.GetTrackEnvelope(track, envidx) end

---@param tr MediaTrack
---@param cfgchunkname_or_guid string
---@return TrackEnvelope
--- Gets a built-in track envelope by configuration chunk name, like "<VOLENV", or GUID string, like "{B577250D-146F-B544-9B34-F24FBE488F1F}".
function reaper.GetTrackEnvelopeByChunkName(tr, cfgchunkname_or_guid) end

---@param track MediaTrack
---@param envname string
---@return TrackEnvelope
function reaper.GetTrackEnvelopeByName(track, envname) end

---@param screen_x integer
---@param screen_y integer
---@return MediaTrack retval, integer info
--- Returns the track from the screen coordinates specified. If the screen coordinates refer to a window associated to the track (such as FX), the track will be returned. infoOutOptional will be set to 1 if it is likely an envelope, 2 if it is likely a track FX. For a free item positioning or fixed lane track, the second byte of infoOutOptional will be set to the (approximate, for fipm tracks) item lane underneath the mouse. See GetThingFromPoint.
function reaper.GetTrackFromPoint(screen_x, screen_y) end

---@param tr MediaTrack
---@return string GUID
function reaper.GetTrackGUID(tr) end

---@param tr MediaTrack
---@param itemidx integer
---@return MediaItem
function reaper.GetTrackMediaItem(tr, itemidx) end

---@param track MediaTrack
---@param flag integer
---@return boolean retval, string buf
--- Get all MIDI lyrics on the track. Lyrics will be returned as one string with tabs between each word. flag&1: double tabs at the end of each measure and triple tabs when skipping measures, flag&2: each lyric is preceded by its beat position in the project (example with flag=2: "1.1.2\tLyric for measure 1 beat 2\t2.1.1\tLyric for measure 2 beat 1 "). See SetTrackMIDILyrics
function reaper.GetTrackMIDILyrics(track, flag) end

---@param track integer
---@param pitch integer
---@param chan integer
---@return string
--- see GetTrackMIDINoteNameEx
function reaper.GetTrackMIDINoteName(track, pitch, chan) end

---@param proj ReaProject
---@param track MediaTrack
---@param pitch integer
---@param chan integer
---@return string
--- Get note/CC name. pitch 128 for CC0 name, 129 for CC1 name, etc. See SetTrackMIDINoteNameEx
function reaper.GetTrackMIDINoteNameEx(proj, track, pitch, chan) end

---@param proj ReaProject
---@param track MediaTrack
---@return integer note_lo, integer note_hi
function reaper.GetTrackMIDINoteRange(proj, track) end

---@param track MediaTrack
---@return boolean retval, string buf
--- Returns "MASTER" for master track, "Track N" if track has no name.
function reaper.GetTrackName(track) end

---@param tr MediaTrack
---@return integer
function reaper.GetTrackNumMediaItems(tr) end

---@param tr MediaTrack
---@param category integer
---@return integer
--- returns number of sends/receives/hardware outputs - category is 0 for hardware outputs
function reaper.GetTrackNumSends(tr, category) end

---@param track MediaTrack
---@param recv_index integer
---@return boolean retval, string buf
--- See GetTrackSendName.
function reaper.GetTrackReceiveName(track, recv_index) end

---@param track MediaTrack
---@param recv_index integer
---@return boolean retval, boolean mute
--- See GetTrackSendUIMute.
function reaper.GetTrackReceiveUIMute(track, recv_index) end

---@param track MediaTrack
---@param recv_index integer
---@return boolean retval, number volume, number pan
--- See GetTrackSendUIVolPan.
function reaper.GetTrackReceiveUIVolPan(track, recv_index) end

---@param tr MediaTrack
---@param category integer
---@param sendidx integer
---@param parmname string
---@return number
--- Get send/receive/hardware output numerical-value attributes. category is 0 for hardware outputs parameter names: B_MUTE : bool * B_PHASE : bool * : true to flip phase B_MONO : bool * D_VOL : double * : 1.0 = +0dB etc D_PAN : double * : -1..+1 D_PANLAW : double * : 1.0=+0.0db, 0.5=-6dB, -1.0 = projdef etc I_SENDMODE : int * : 0=post-fader, 1=pre-fx, 2=post-fx (deprecated), 3=post-fx I_AUTOMODE : int * : automation mode (-1=use track automode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch) I_SRCCHAN : int * : -1 for no audio send. Low 10 bits specify channel offset, and higher bits specify channel count. (srcchan>>10) == 0 for stereo, 1 for mono, 2 for 4 channel, 3 for 6 channel, etc. I_DSTCHAN : int * : low 10 bits are destination index, &1024 set to mix to mono. I_MIDIFLAGS : int * : low 5 bits=source channel 0=all, 1-16, 31=MIDI send disabled, next 5 bits=dest channel, 0=orig, 1-16=chan. &1024 for faders-send MIDI vol/pan. (>>14)&255 = src bus (0 for all, 1 for normal, 2+). (>>22)&255=destination bus (0 for all, 1 for normal, 2+) P_DESTTRACK : MediaTrack * : destination track, only applies for sends/recvs (read-only) P_SRCTRACK : MediaTrack * : source track, only applies for sends/recvs (read-only) P_ENV:<envchunkname : TrackEnvelope * : call with :<VOLENV, :<PANENV, etc appended (read-only) See CreateTrackSend , RemoveTrackSend , GetTrackNumSends.
function reaper.GetTrackSendInfo_Value(tr, category, sendidx, parmname) end

---@param track MediaTrack
---@param send_index integer
---@return boolean retval, string buf
--- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveName.
function reaper.GetTrackSendName(track, send_index) end

---@param track MediaTrack
---@param send_index integer
---@return boolean retval, boolean mute
--- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveUIMute.
function reaper.GetTrackSendUIMute(track, send_index) end

---@param track MediaTrack
---@param send_index integer
---@return boolean retval, number volume, number pan
--- send_idx>=0 for hw ouputs, >=nb_of_hw_ouputs for sends. See GetTrackReceiveUIVolPan.
function reaper.GetTrackSendUIVolPan(track, send_index) end

---@param track MediaTrack
---@return string retval, integer flags
--- Gets track state, returns track name. flags will be set to: &1=folder &2=selected &4=has fx enabled &8=muted &16=soloed &32=SIP'd (with &16) &64=rec armed &128=rec monitoring on &256=rec monitoring auto &512=hide from TCP &1024=hide from MCP
function reaper.GetTrackState(track) end

---@param track MediaTrack
---@param str string
---@param isundo boolean
---@return boolean retval, string str
--- Gets the RPPXML state of a track, returns true if successful. Undo flag is a performance/caching hint.
function reaper.GetTrackStateChunk(track, str, isundo) end

---@param track MediaTrack
---@return boolean retval, boolean mute
function reaper.GetTrackUIMute(track) end

---@param track MediaTrack
---@return boolean retval, number pan1, number pan2, integer panmode
function reaper.GetTrackUIPan(track) end

---@param track MediaTrack
---@return boolean retval, number volume, number pan
function reaper.GetTrackUIVolPan(track) end

---@return integer audio_xrun, integer media_xrun, integer curtime
--- retrieves the last timestamps of audio xrun (yellow-flash, if available), media xrun (red-flash), and the current time stamp (all milliseconds)
function reaper.GetUnderrunTime() end

---@param filenameNeed4096 string
---@param title string
---@param defext string
---@return boolean retval, string filenameNeed4096
--- returns true if the user selected a valid file, false if the user canceled the dialog
function reaper.GetUserFileNameForRead(filenameNeed4096, title, defext) end

---@param title string
---@param num_inputs integer
---@param captions_csv string
---@param retvals_csv string
---@return boolean retval, string retvals_csv
--- Get values from the user. If a caption begins with *, for example "*password", the edit field will not display the input text. Maximum fields is 16. Values are returned as a comma-separated string. Returns false if the user canceled the dialog. You can supply special extra information via additional caption fields: extrawidth=XXX to increase text field width, separator=X to use a different separator for returned fields.
function reaper.GetUserInputs(title, num_inputs, captions_csv, retvals_csv) end

---@param proj ReaProject
---@param marker_index integer
---@param use_timeline_order boolean
--- Go to marker. If use_timeline_order==true, marker_index 1 refers to the first marker on the timeline. If use_timeline_order==false, marker_index 1 refers to the first marker with the user-editable index of 1.
function reaper.GoToMarker(proj, marker_index, use_timeline_order) end

---@param proj ReaProject
---@param region_index integer
---@param use_timeline_order boolean
--- Seek to region after current region finishes playing (smooth seek). If use_timeline_order==true, region_index 1 refers to the first region on the timeline. If use_timeline_order==false, region_index 1 refers to the first region with the user-editable index of 1.
function reaper.GoToRegion(proj, region_index, use_timeline_order) end

---@param hwnd HWND
---@return integer retval, integer color
--- Runs the system color chooser dialog. Returns 0 if the user cancels the dialog.
function reaper.GR_SelectColor(hwnd) end

---@param t integer
---@return integer
--- this is just like win32 GetSysColor() but can have overrides.
function reaper.GSC_mainwnd(t) end

---@param gGUID string
---@param destNeed64 string
---@return string destNeed64
--- dest should be at least 64 chars long to be safe
function reaper.guidToString(gGUID, destNeed64) end

---@param section string
---@param key string
---@return boolean
--- Returns true if there exists an extended state value for a specific section and key. See SetExtState , GetExtState , DeleteExtState.
function reaper.HasExtState(section, key) end

---@param track integer
---@return string
--- returns name of track plugin that is supplying MIDI programs,or NULL if there is none
function reaper.HasTrackMIDIPrograms(track) end

---@param proj ReaProject
---@param track MediaTrack
---@return string
--- returns name of track plugin that is supplying MIDI programs,or NULL if there is none
function reaper.HasTrackMIDIProgramsEx(proj, track) end

---@param helpstring string
---@param is_temporary_help boolean
function reaper.Help_Set(helpstring, is_temporary_help) end

---@param in_ string
---@param out string
---@return string out
function reaper.image_resolve_fn(in_, out) end

---@param env TrackEnvelope
---@param pool_id integer
---@param position number
---@param length number
---@return integer
--- Insert a new automation item. pool_id = 0 the automation item will be a new instance of that pool (which will be created as an empty instance if it does not exist). Returns the index of the item, suitable for passing to other automation item API functions. See GetSetAutomationItemInfo.
function reaper.InsertAutomationItem(env, pool_id, position, length) end

---@param envelope TrackEnvelope
---@param time number
---@param value number
---@param shape integer
---@param tension number
---@param selected boolean
---@param noSortIn optional boolean
---@return boolean
--- Insert an envelope point. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. See InsertEnvelopePointEx.
function reaper.InsertEnvelopePoint(envelope, time, value, shape, tension, selected, noSortIn) end

---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param time number
---@param value number
---@param shape integer
---@param tension number
---@param selected boolean
---@param noSortIn optional boolean
---@return boolean
--- Insert an envelope point. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc. For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration, even if the automation item is trimmed so that not all points are visible. Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations. See CountEnvelopePointsEx , GetEnvelopePointEx , SetEnvelopePointEx , DeleteEnvelopePointEx.
function reaper.InsertEnvelopePointEx(envelope, autoitem_idx, time, value, shape, tension, selected, noSortIn) end

---@param file string
---@param mode integer
---@return integer
--- mode: 0=add to current track, 1=add new track, 3=add to selected items as takes, &4=stretch/loop to fit time sel, &8=try to match tempo 1x, &16=try to match tempo 0.5x, &32=try to match tempo 2x, &64=don't preserve pitch when matching tempo, &128=no loop/section if startpct/endpct set, &256=force loop regardless of global preference for looping imported items, &512=use high word as absolute track index if mode&3==0 or mode&2048, &1024=insert into reasamplomatic on a new track (add 1 to insert on last selected track), &2048=insert into open reasamplomatic instance (add 512 to use high word as absolute track index), &4096=move to source preferred position (BWF start offset), &8192=reverse. &16384=apply ripple according to project setting
function reaper.InsertMedia(file, mode) end

---@param file string
---@param mode integer
---@param startpct number
---@param endpct number
---@param pitchshift number
---@return integer
--- See InsertMedia.
function reaper.InsertMediaSection(file, mode, startpct, endpct, pitchshift) end

---@param idx integer
---@param wantDefaults boolean
--- inserts a track at idx,of course this will be clamped to 0..GetNumTracks(). wantDefaults=TRUE for default envelopes/FX,otherwise no enabled fx/env. Superseded, see InsertTrackInProject
function reaper.InsertTrackAtIndex(idx, wantDefaults) end

---@param proj ReaProject
---@param idx integer
---@param flags integer
--- inserts a track in project proj at idx, this will be clamped to 0..CountTracks(proj). flags&1 for default envelopes/FX, otherwise no enabled fx/envelopes will be added.
function reaper.InsertTrackInProject(proj, idx, flags) end

---@param ext string
---@param wantOthers boolean
---@return boolean
--- Tests a file extension (i.e. "wav" or "mid") to see if it's a media extension. If wantOthers is set, then "RPP", "TXT" and other project-type formats will also pass.
function reaper.IsMediaExtension(ext, wantOthers) end

---@param item MediaItem
---@return boolean
function reaper.IsMediaItemSelected(item) end

---@param proj ReaProject
---@return integer
--- Is the project dirty (needing save)? Always returns 0 if 'undo/prompt to save' is disabled in preferences.
function reaper.IsProjectDirty(proj) end

---@param track MediaTrack
---@return boolean
function reaper.IsTrackSelected(track) end

---@param track MediaTrack
---@param mixer boolean
---@return boolean
--- If mixer==true, returns true if the track is visible in the mixer. If mixer==false, returns true if the track is visible in the track control panel.
function reaper.IsTrackVisible(track, mixer) end

---@param guidGUID string
---@return joystick_device
--- creates a joystick device
function reaper.joystick_create(guidGUID) end

---@param device joystick_device
--- destroys a joystick device
function reaper.joystick_destroy(device) end

---@param index integer
---@return string retval, string namestr
--- enumerates installed devices, returns GUID as a string
function reaper.joystick_enum(index) end

---@param dev joystick_device
---@param axis integer
---@return number
--- returns axis value (-1..1)
function reaper.joystick_getaxis(dev, axis) end

---@param dev joystick_device
---@return integer
--- returns button pressed mask, 1=first button, 2=second...
function reaper.joystick_getbuttonmask(dev) end

---@param dev joystick_device
---@return integer retval, integer axes, integer povs
--- returns button count
function reaper.joystick_getinfo(dev) end

---@param dev joystick_device
---@param pov integer
---@return number
--- returns POV value (usually 0..655.35, or 655.35 on error)
function reaper.joystick_getpov(dev, pov) end

---@param dev joystick_device
---@return boolean
--- Updates joystick state from hardware, returns true if successful (joystick_get* will not be valid until joystick_update() is called successfully)
function reaper.joystick_update(dev) end

---@param section KbdSectionInfo
---@param idx integer
---@return integer retval, string name
function reaper.kbd_enumerateActions(section, idx) end

---@param cmd integer
---@param section KbdSectionInfo
---@return string
function reaper.kbd_getTextFromCmd(cmd, section) end

---@param pX1 integer
---@param pY1 integer
---@param pX2 integer
---@param pY2 integer
---@param xLo integer
---@param yLo integer
---@param xHi integer
---@param yHi integer
---@return boolean retval, integer pX1, integer pY1, integer pX2, integer pY2
--- Returns false if the line is entirely offscreen.
function reaper.LICE_ClipLine(pX1, pY1, pX2, pY2, xLo, yLo, xHi, yHi) end

---@param src_string string
---@param section string
---@param flags integer
---@return string
--- Returns a localized version of src_string, in section section. flags can have 1 set to only localize if sprintf-style formatting matches the original.
function reaper.LocalizeString(src_string, section, flags) end

---@param project ReaProject
---@param direction integer
---@return boolean
--- Move the loop selection left or right. Returns true if snap is enabled.
function reaper.Loop_OnArrow(project, direction) end

---@param command integer
---@param flag integer
--- See Main_OnCommandEx.
function reaper.Main_OnCommand(command, flag) end

---@param command integer
---@param flag integer
---@param proj ReaProject
--- Performs an action belonging to the main action section. To perform non-native actions (ReaScripts, custom or extension plugins' actions) safely, see NamedCommandLookup ().
function reaper.Main_OnCommandEx(command, flag, proj) end

---@param name string
--- opens a project. will prompt the user to save unless name is prefixed with 'noprompt:'. If name is prefixed with 'template:', project file will be loaded as a template. If passed a .RTrackTemplate file, adds the template to the existing project.
function reaper.Main_openProject(name) end

---@param proj ReaProject
---@param forceSaveAsIn boolean
--- Save the project.
function reaper.Main_SaveProject(proj, forceSaveAsIn) end

---@param proj ReaProject
---@param filename string
---@param options integer
--- Save the project. options: &1=save selected tracks as track template, &2=include media with track template, &4=include envelopes with track template, &8=if not saving template, set as the new project filename for this ReaProject. See Main_openProject , Main_SaveProject.
function reaper.Main_SaveProjectEx(proj, filename, options) end

---@param ignoremask integer
function reaper.Main_UpdateLoopInfo(ignoremask) end

---@param proj ReaProject
--- Marks project as dirty (needing save) if 'undo/prompt to save' is enabled in preferences.
function reaper.MarkProjectDirty(proj) end

---@param track MediaTrack
---@param item MediaItem
--- If track is supplied, item is ignored
function reaper.MarkTrackItemsDirty(track, item) end

---@param project ReaProject
---@return number
function reaper.Master_GetPlayRate(project) end

---@param time_s number
---@param proj ReaProject
---@return number
function reaper.Master_GetPlayRateAtTime(time_s, proj) end

---@return number
function reaper.Master_GetTempo() end

---@param playrate number
---@param isnormalized boolean
---@return number
--- Convert play rate to/from a value between 0 and 1, representing the position on the project playrate slider.
function reaper.Master_NormalizePlayRate(playrate, isnormalized) end

---@param bpm number
---@param isnormalized boolean
---@return number
--- Convert the tempo to/from a value between 0 and 1, representing bpm in the range of 40-296 bpm.
function reaper.Master_NormalizeTempo(bpm, isnormalized) end

---@param msg string
---@param title string
---@param type integer
---@return integer
--- type 0=OK,1=OKCANCEL,2=ABORTRETRYIGNORE,3=YESNOCANCEL,4=YESNO,5=RETRYCANCEL : ret 1=OK,2=CANCEL,3=ABORT,4=RETRY,5=IGNORE,6=YES,7=NO
function reaper.MB(msg, title, type) end

---@return boolean retval, string filename, integer filemode, number selstart, number selend, number pitchshift, number voladj, number rateadj, number sourcebpm, string extrainfo
--- Get information about the most recently previewed Media Explorer file. filename: last played file name. filemode: &1:insert on new track, &2:insert into sampler, &8:tempo sync 1x, &16:tempo sync 0.5x, &32:tempo sync 2x, &64:do not preserve pitch when changing playrate, &128:loop selection exists, &256:time selection exists, &512:apply pitch/rate adjustment on insert, &1024:apply volume adjustment on insert, &2048:apply normalization on insert, &8192:reverse preview. startpct/endpct: time selection in [0.0, 1.0]. pitchshift/voladj/rateadj: current pitch/volume/playrate preview adjustments. srcbpm: source media tempo. extrainfo: currently unused.
function reaper.MediaExplorerGetLastPlayedFileInfo() end

---@param item MediaItem
---@param track MediaTrack
---@return integer
--- Returns 1 if the track holds the item, 2 if the track is a folder containing the track that holds the item, etc.
function reaper.MediaItemDescendsFromTrack(item, track) end

---@param menuname string
---@param flag integer
---@return boolean retval, string hash
--- Get a string that only changes when menu/toolbar entries are added or removed (not re-ordered). Can be used to determine if a customized menu/toolbar differs from the default, or if the default changed after a menu/toolbar was customized. flag==0: current default menu/toolbar; flag==1: current customized menu/toolbar; flag==2: default menu/toolbar at the time the current menu/toolbar was most recently customized, if it was customized in REAPER v7.08 or later.
function reaper.Menu_GetHash(menuname, flag) end

---@param take MediaItem_Take
---@return integer retval, integer notecnt, integer ccevtcnt, integer textsyxevtcnt
--- Count the number of notes, CC events, and text/sysex events in a given MIDI item.
function reaper.MIDI_CountEvts(take) end

---@param take MediaItem_Take
---@param ccidx integer
---@return boolean
--- Delete a MIDI CC event.
function reaper.MIDI_DeleteCC(take, ccidx) end

---@param take MediaItem_Take
---@param evtidx integer
---@return boolean
--- Delete a MIDI event.
function reaper.MIDI_DeleteEvt(take, evtidx) end

---@param take MediaItem_Take
---@param noteidx integer
---@return boolean
--- Delete a MIDI note.
function reaper.MIDI_DeleteNote(take, noteidx) end

---@param take MediaItem_Take
---@param textsyxevtidx integer
---@return boolean
--- Delete a MIDI text or sysex event.
function reaper.MIDI_DeleteTextSysexEvt(take, textsyxevtidx) end

---@param take MediaItem_Take
--- Disable sorting for all MIDI insert, delete, get and set functions, until MIDI_Sort is called.
function reaper.MIDI_DisableSort(take) end

---@param take MediaItem_Take
---@param ccidx integer
---@return integer
--- Returns the index of the next selected MIDI CC event after ccidx (-1 if there are no more selected events).
function reaper.MIDI_EnumSelCC(take, ccidx) end

---@param take MediaItem_Take
---@param evtidx integer
---@return integer
--- Returns the index of the next selected MIDI event after evtidx (-1 if there are no more selected events).
function reaper.MIDI_EnumSelEvts(take, evtidx) end

---@param take MediaItem_Take
---@param noteidx integer
---@return integer
--- Returns the index of the next selected MIDI note after noteidx (-1 if there are no more selected events).
function reaper.MIDI_EnumSelNotes(take, noteidx) end

---@param take MediaItem_Take
---@param textsyxidx integer
---@return integer
--- Returns the index of the next selected MIDI text/sysex event after textsyxidx (-1 if there are no more selected events).
function reaper.MIDI_EnumSelTextSysexEvts(take, textsyxidx) end

---@param take MediaItem_Take
---@return boolean retval, string buf
--- Get all MIDI data. MIDI buffer is returned as a list of { int offset, char flag, int msglen, unsigned char msg[] }. offset: MIDI ticks from previous event flag: &1=selected &2=muted flag high 4 bits for CC shape: &16=linear, &32=slow start/end, &16|32=fast start, &64=fast end, &64|16=bezier msg: the MIDI message. A meta-event of type 0xF followed by 'CCBZ ' and 5 more bytes represents bezier curve data for the previous MIDI event: 1 byte for the bezier type (usually 0) and 4 bytes for the bezier tension as a float. For tick intervals longer than a 32 bit word can represent, zero-length meta events may be placed between valid events. See MIDI_SetAllEvts.
function reaper.MIDI_GetAllEvts(take) end

---@param take MediaItem_Take
---@param ccidx integer
---@return boolean retval, boolean selected, boolean muted, number ppqpos, integer chanmsg, integer chan, integer msg2, integer msg3
--- Get MIDI CC event properties.
function reaper.MIDI_GetCC(take, ccidx) end

---@param take MediaItem_Take
---@param ccidx integer
---@return boolean retval, integer shape, number beztension
--- Get CC shape and bezier tension. See MIDI_GetCC , MIDI_SetCCShape
function reaper.MIDI_GetCCShape(take, ccidx) end

---@param take MediaItem_Take
---@param evtidx integer
---@return boolean retval, boolean selected, boolean muted, number ppqpos, string msg
--- Get MIDI event properties.
function reaper.MIDI_GetEvt(take, evtidx) end

---@param take MediaItem_Take
---@return number retval, number swing, number noteLen
--- Returns the most recent MIDI editor grid size for this MIDI take, in QN. Swing is between 0 and 1. Note length is 0 if it follows the grid size.
function reaper.MIDI_GetGrid(take) end

---@param take MediaItem_Take
---@param notesonly boolean
---@return boolean retval, string hash
--- Get a string that only changes when the MIDI data changes. If notesonly==true, then the string changes only when the MIDI notes change. See MIDI_GetTrackHash
function reaper.MIDI_GetHash(take, notesonly) end

---@param take MediaItem_Take
---@param noteidx integer
---@return boolean retval, boolean selected, boolean muted, number startppqpos, number endppqpos, integer chan, integer pitch, integer vel
--- Get MIDI note properties.
function reaper.MIDI_GetNote(take, noteidx) end

---@param take MediaItem_Take
---@param ppqpos number
---@return number
--- Returns the MIDI tick (ppq) position corresponding to the end of the measure.
function reaper.MIDI_GetPPQPos_EndOfMeasure(take, ppqpos) end

---@param take MediaItem_Take
---@param ppqpos number
---@return number
--- Returns the MIDI tick (ppq) position corresponding to the start of the measure.
function reaper.MIDI_GetPPQPos_StartOfMeasure(take, ppqpos) end

---@param take MediaItem_Take
---@param projqn number
---@return number
--- Returns the MIDI tick (ppq) position corresponding to a specific project time in quarter notes.
function reaper.MIDI_GetPPQPosFromProjQN(take, projqn) end

---@param take MediaItem_Take
---@param projtime number
---@return number
--- Returns the MIDI tick (ppq) position corresponding to a specific project time in seconds.
function reaper.MIDI_GetPPQPosFromProjTime(take, projtime) end

---@param take MediaItem_Take
---@param ppqpos number
---@return number
--- Returns the project time in quarter notes corresponding to a specific MIDI tick (ppq) position.
function reaper.MIDI_GetProjQNFromPPQPos(take, ppqpos) end

---@param take MediaItem_Take
---@param ppqpos number
---@return number
--- Returns the project time in seconds corresponding to a specific MIDI tick (ppq) position.
function reaper.MIDI_GetProjTimeFromPPQPos(take, ppqpos) end

---@param idx integer
---@return integer retval, string buf, integer ts, integer devIdx, number projPos, integer projLoopCnt
--- Gets a recent MIDI input event from the global history. idx=0 for the most recent event, which also latches to the latest MIDI event state (to get a more recent list, calling with idx=0 is necessary). idx=1 next most recent event, returns a non-zero sequence number for the event, or zero if no more events. tsOut will be set to the timestamp in samples relative to the current position (0 is current, -48000 is one second ago, etc). devIdxOut will have the low 16 bits set to the input device index, and 0x10000 will be set if device was enabled only for control. projPosOut will be set to project position in seconds if project was playing back at time of event, otherwise -1. Large SysEx events will not be included in this event list.
function reaper.MIDI_GetRecentInputEvent(idx) end

---@param take MediaItem_Take
---@return boolean retval, integer root, integer scale, string name
--- Get the active scale in the media source, if any. root 0=C, 1=C#, etc. scale &0x1=root, &0x2=minor 2nd, &0x4=major 2nd, &0x8=minor 3rd, &0xF=fourth, etc.
function reaper.MIDI_GetScale(take) end

---@param take MediaItem_Take
---@param textsyxevtidx integer
---@param selected optional boolean
---@param muted optional boolean
---@param ppqpos optional number
---@param type optional integer
---@param msg optional string
---@return boolean retval, boolean selected, boolean muted, number ppqpos, integer type, string msg
--- Get MIDI meta-event properties. Allowable types are -1:sysex (msg should not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event. For all other meta-messages, type is returned as -2 and msg returned as all zeroes. See MIDI_GetEvt.
function reaper.MIDI_GetTextSysexEvt(take, textsyxevtidx, selected, muted, ppqpos, type, msg) end

---@param track MediaTrack
---@param notesonly boolean
---@return boolean retval, string hash
--- Get a string that only changes when the MIDI data changes. If notesonly==true, then the string changes only when the MIDI notes change. See MIDI_GetHash
function reaper.MIDI_GetTrackHash(track, notesonly) end

---@param force_reinit_input integer
---@param force_reinit_output integer
--- Opens MIDI devices as configured in preferences. force_reinit_input and force_reinit_output force a particular device index to close/re-open (pass -1 to not force any devices to reopen).
function reaper.midi_init(force_reinit_input, force_reinit_output) end

---@param take MediaItem_Take
---@param selected boolean
---@param muted boolean
---@param ppqpos number
---@param chanmsg integer
---@param chan integer
---@param msg2 integer
---@param msg3 integer
---@return boolean
--- Insert a new MIDI CC event.
function reaper.MIDI_InsertCC(take, selected, muted, ppqpos, chanmsg, chan, msg2, msg3) end

---@param take MediaItem_Take
---@param selected boolean
---@param muted boolean
---@param ppqpos number
---@param bytestr string
---@return boolean
--- Insert a new MIDI event.
function reaper.MIDI_InsertEvt(take, selected, muted, ppqpos, bytestr) end

---@param take MediaItem_Take
---@param selected boolean
---@param muted boolean
---@param startppqpos number
---@param endppqpos number
---@param chan integer
---@param pitch integer
---@param vel integer
---@param noSortIn optional boolean
---@return boolean
--- Insert a new MIDI note. Set noSort if inserting multiple events, then call MIDI_Sort when done.
function reaper.MIDI_InsertNote(take, selected, muted, startppqpos, endppqpos, chan, pitch, vel, noSortIn) end

---@param take MediaItem_Take
---@param selected boolean
---@param muted boolean
---@param ppqpos number
---@param type integer
---@param bytestr string
---@return boolean
--- Insert a new MIDI text or sysex event. Allowable types are -1:sysex (msg should not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event.
function reaper.MIDI_InsertTextSysexEvt(take, selected, muted, ppqpos, type, bytestr) end

---@param tk MediaItem_Take
--- Synchronously updates any open MIDI editors for MIDI take
function reaper.MIDI_RefreshEditors(tk) end

--- Reset (close and re-open) all MIDI devices
function reaper.midi_reinit() end

---@param take MediaItem_Take
---@param select boolean
--- Select or deselect all MIDI content.
function reaper.MIDI_SelectAll(take, select) end

---@param take MediaItem_Take
---@param buf string
---@return boolean
--- Set all MIDI data. MIDI buffer is passed in as a list of { int offset, char flag, int msglen, unsigned char msg[] }. offset: MIDI ticks from previous event flag: &1=selected &2=muted flag high 4 bits for CC shape: &16=linear, &32=slow start/end, &16|32=fast start, &64=fast end, &64|16=bezier msg: the MIDI message. A meta-event of type 0xF followed by 'CCBZ ' and 5 more bytes represents bezier curve data for the previous MIDI event: 1 byte for the bezier type (usually 0) and 4 bytes for the bezier tension as a float. For tick intervals longer than a 32 bit word can represent, zero-length meta events may be placed between valid events. See MIDI_GetAllEvts.
function reaper.MIDI_SetAllEvts(take, buf) end

---@param take MediaItem_Take
---@param ccidx integer
---@param selectedIn optional boolean
---@param mutedIn optional boolean
---@param ppqposIn optional number
---@param chanmsgIn optional integer
---@param chanIn optional integer
---@param msg2In optional integer
---@param msg3In optional integer
---@param noSortIn optional boolean
---@return boolean
--- Set MIDI CC event properties. Properties passed as NULL will not be set. set noSort if setting multiple events, then call MIDI_Sort when done.
function reaper.MIDI_SetCC(take, ccidx, selectedIn, mutedIn, ppqposIn, chanmsgIn, chanIn, msg2In, msg3In, noSortIn) end

---@param take MediaItem_Take
---@param ccidx integer
---@param shape integer
---@param beztension number
---@param noSortIn optional boolean
---@return boolean
--- Set CC shape and bezier tension. set noSort if setting multiple events, then call MIDI_Sort when done. See MIDI_SetCC , MIDI_GetCCShape
function reaper.MIDI_SetCCShape(take, ccidx, shape, beztension, noSortIn) end

---@param take MediaItem_Take
---@param evtidx integer
---@param selectedIn optional boolean
---@param mutedIn optional boolean
---@param ppqposIn optional number
---@param msg optional string
---@param noSortIn optional boolean
---@return boolean
--- Set MIDI event properties. Properties passed as NULL will not be set. set noSort if setting multiple events, then call MIDI_Sort when done.
function reaper.MIDI_SetEvt(take, evtidx, selectedIn, mutedIn, ppqposIn, msg, noSortIn) end

---@param item MediaItem
---@param startQN number
---@param endQN number
---@return boolean
--- Set the start/end positions of a media item that contains a MIDI take.
function reaper.MIDI_SetItemExtents(item, startQN, endQN) end

---@param take MediaItem_Take
---@param noteidx integer
---@param selectedIn optional boolean
---@param mutedIn optional boolean
---@param startppqposIn optional number
---@param endppqposIn optional number
---@param chanIn optional integer
---@param pitchIn optional integer
---@param velIn optional integer
---@param noSortIn optional boolean
---@return boolean
--- Set MIDI note properties. Properties passed as NULL (or negative values) will not be set. Set noSort if setting multiple events, then call MIDI_Sort when done. Setting multiple note start positions at once is done more safely by deleting and re-inserting the notes.
function reaper.MIDI_SetNote(take, noteidx, selectedIn, mutedIn, startppqposIn, endppqposIn, chanIn, pitchIn, velIn,
                             noSortIn)
end

---@param take MediaItem_Take
---@param textsyxevtidx integer
---@param selectedIn optional boolean
---@param mutedIn optional boolean
---@param ppqposIn optional number
---@param typeIn optional integer
---@param msg optional string
---@param noSortIn optional boolean
---@return boolean
--- Set MIDI text or sysex event properties. Properties passed as NULL will not be set. Allowable types are -1:sysex (msg should not include bounding F0..F7), 1-14:MIDI text event types, 15=REAPER notation event. set noSort if setting multiple events, then call MIDI_Sort when done.
function reaper.MIDI_SetTextSysexEvt(take, textsyxevtidx, selectedIn, mutedIn, ppqposIn, typeIn, msg, noSortIn) end

---@param take MediaItem_Take
--- Sort MIDI events after multiple calls to MIDI_SetNote, MIDI_SetCC, etc.
function reaper.MIDI_Sort(take) end

---@param midieditor HWND
---@param takeindex integer
---@param editable_only boolean
---@return MediaItem_Take
--- list the takes that are currently being edited in this MIDI editor, starting with the active take. See MIDIEditor_GetTake
function reaper.MIDIEditor_EnumTakes(midieditor, takeindex, editable_only) end

---@return HWND
--- get a pointer to the focused MIDI editor window see MIDIEditor_GetMode , MIDIEditor_OnCommand
function reaper.MIDIEditor_GetActive() end

---@param midieditor HWND
---@return integer
--- get the mode of a MIDI editor (0=piano roll, 1=event list, -1=invalid editor) see MIDIEditor_GetActive , MIDIEditor_OnCommand
function reaper.MIDIEditor_GetMode(midieditor) end

---@param midieditor HWND
---@param setting_desc string
---@return integer
--- Get settings from a MIDI editor. setting_desc can be: snap_enabled: returns 0 or 1 active_note_row: returns 0-127 last_clicked_cc_lane: returns 0-127=CC, 0x100|(0-31)=14-bit CC, 0x200=velocity, 0x201=pitch, 0x202=program, 0x203=channel pressure, 0x204=bank/program select, 0x205=text, 0x206=sysex, 0x207=off velocity, 0x208=notation events, 0x209=aftertouch, 0x210=media item lane default_note_vel: returns 0-127 default_note_chan: returns 0-15 default_note_len: returns default length in MIDI ticks scale_enabled: returns 0-1 scale_root: returns 0-12 (0=C) list_cnt: if viewing list view, returns event count if setting_desc is unsupported, the function returns -1. See MIDIEditor_SetSetting_int , MIDIEditor_GetActive , MIDIEditor_GetSetting_str
function reaper.MIDIEditor_GetSetting_int(midieditor, setting_desc) end

---@param midieditor HWND
---@param setting_desc string
---@return boolean retval, string buf
--- Get settings from a MIDI editor. setting_desc can be: last_clicked_cc_lane: returns text description ("velocity", "pitch", etc) scale: returns the scale record, for example "102034050607" for a major scale list_X: if viewing list view, returns string describing event at row X (0-based). String will have a list of key=value pairs, e.g. 'pos=4.0 len=4.0 offvel=127 msg=90317F'. pos/len times are in QN, len/offvel may not be present if event is not a note. other keys which may be present include pos_pq/len_pq, sel, mute, ccval14, ccshape, ccbeztension. if setting_desc is unsupported, the function returns false. See MIDIEditor_GetActive , MIDIEditor_GetSetting_int
function reaper.MIDIEditor_GetSetting_str(midieditor, setting_desc) end

---@param midieditor HWND
---@return MediaItem_Take
--- get the take that is currently being edited in this MIDI editor. see MIDIEditor_EnumTakes
function reaper.MIDIEditor_GetTake(midieditor) end

---@param command_id integer
---@param islistviewcommand boolean
---@return boolean
--- Send an action command to the last focused MIDI editor. Returns false if there is no MIDI editor open, or if the view mode (piano roll or event list) does not match the input. see MIDIEditor_OnCommand
function reaper.MIDIEditor_LastFocused_OnCommand(command_id, islistviewcommand) end

---@param midieditor HWND
---@param command_id integer
---@return boolean
--- Send an action command to a MIDI editor. Returns false if the supplied MIDI editor pointer is not valid (not an open MIDI editor). see MIDIEditor_GetActive , MIDIEditor_LastFocused_OnCommand
function reaper.MIDIEditor_OnCommand(midieditor, command_id) end

---@param midieditor HWND
---@param setting_desc string
---@param setting integer
---@return boolean
--- Set settings for a MIDI editor. setting_desc can be: active_note_row: 0-127 See MIDIEditor_GetSetting_int
function reaper.MIDIEditor_SetSetting_int(midieditor, setting_desc, setting) end

---@param track MediaTrack
---@param pitchwheelrange integer
---@param flags integer
---@param is_set boolean
---@return integer pitchwheelrange, integer flags
--- Get or set MIDI editor settings for this track. pitchwheelrange: semitones up or down. flags &1: snap pitch lane edits to semitones if pitchwheel range is defined.
function reaper.MIDIEditorFlagsForTrack(track, pitchwheelrange, flags, is_set) end

---@param strNeed64 string
---@param pan number
---@return string strNeed64
function reaper.mkpanstr(strNeed64, pan) end

---@param strNeed64 string
---@param vol number
---@param pan number
---@return string strNeed64
function reaper.mkvolpanstr(strNeed64, vol, pan) end

---@param strNeed64 string
---@param vol number
---@return string strNeed64
function reaper.mkvolstr(strNeed64, vol) end

---@param adjamt number
---@param dosel boolean
function reaper.MoveEditCursor(adjamt, dosel) end

---@param item MediaItem
---@param desttr MediaTrack
---@return boolean
--- returns TRUE if move succeeded
function reaper.MoveMediaItemToTrack(item, desttr) end

---@param mute boolean
function reaper.MuteAllTracks(mute) end

---@param wantWorkArea boolean
function reaper.my_getViewport(wantWorkArea) end

---@param command_name string
---@return integer
--- Get the command ID number for named command that was registered by an extension such as "_SWS_ABOUT" or "_113088d11ae641c193a2b7ede3041ad5" for a ReaScript or a custom action.
function reaper.NamedCommandLookup(command_name) end

--- direct way to simulate pause button hit
function reaper.OnPauseButton() end

---@param proj ReaProject
--- direct way to simulate pause button hit
function reaper.OnPauseButtonEx(proj) end

--- direct way to simulate play button hit
function reaper.OnPlayButton() end

---@param proj ReaProject
--- direct way to simulate play button hit
function reaper.OnPlayButtonEx(proj) end

--- direct way to simulate stop button hit
function reaper.OnStopButton() end

---@param proj ReaProject
--- direct way to simulate stop button hit
function reaper.OnStopButtonEx(proj) end

---@param fn string
---@return boolean
function reaper.OpenColorThemeFile(fn) end

---@param mediafn string
---@param play boolean
---@return HWND
--- Opens mediafn in the Media Explorer, play=true will play the file immediately (or toggle playback if mediafn was already open), =false will just select it.
function reaper.OpenMediaExplorer(mediafn, play) end

---@param message string
---@param valueIn optional number
--- Send an OSC message directly to REAPER. The value argument may be NULL. The message will be matched against the default OSC patterns.
function reaper.OscLocalMessageToHost(message, valueIn) end

---@param buf string
---@return number
--- Parse hh:mm:ss.sss time string, return time in seconds (or 0.0 on error). See parse_timestr_pos , parse_timestr_len.
function reaper.parse_timestr(buf) end

---@param buf string
---@param offset number
---@param modeoverride integer
---@return number
--- time formatting mode overrides: -1=proj default. 0=time 1=measures.beats + time 2=measures.beats 3=seconds 4=samples 5=h:m:s:f
function reaper.parse_timestr_len(buf, offset, modeoverride) end

---@param buf string
---@param modeoverride integer
---@return number
--- Parse time string, time formatting mode overrides: -1=proj default. 0=time 1=measures.beats + time 2=measures.beats 3=seconds 4=samples 5=h:m:s:f
function reaper.parse_timestr_pos(buf, modeoverride) end

---@param str string
---@return number
function reaper.parsepanstr(str) end

---@param idx integer
---@return integer retval, string descstr
function reaper.PCM_Sink_Enum(idx) end

---@param data string
---@return string
function reaper.PCM_Sink_GetExtension(data) end

---@param cfg string
---@param hwndParent HWND
---@return HWND
function reaper.PCM_Sink_ShowConfig(cfg, hwndParent) end

---@param src PCM_source
---@param mode integer
---@return integer
--- Calls and returns PCM_source::PeaksBuild_Begin() if mode=0, PeaksBuild_Run() if mode=1, and PeaksBuild_Finish() if mode=2. Normal use is to call PCM_Source_BuildPeaks(src,0), and if that returns nonzero, call PCM_Source_BuildPeaks(src,1) periodically until it returns zero (it returns the percentage of the file remaining), then call PCM_Source_BuildPeaks(src,2) to finalize. If PCM_Source_BuildPeaks(src,0) returns zero, then no further action is necessary.
function reaper.PCM_Source_BuildPeaks(src, mode) end

---@param filename string
---@return PCM_source
--- See PCM_Source_CreateFromFileEx.
function reaper.PCM_Source_CreateFromFile(filename) end

---@param filename string
---@param forcenoMidiImp boolean
---@return PCM_source
--- Create a PCM_source from filename, and override pref of MIDI files being imported as in-project MIDI events.
function reaper.PCM_Source_CreateFromFileEx(filename, forcenoMidiImp) end

---@param sourcetype string
---@return PCM_source
--- Create a PCM_source from a "type" (use this if you're going to load its state via LoadState/ProjectStateContext). Valid types include "WAVE", "MIDI", or whatever plug-ins define as well.
function reaper.PCM_Source_CreateFromType(sourcetype) end

---@param src PCM_source
--- Deletes a PCM_source -- be sure that you remove any project reference before deleting a source
function reaper.PCM_Source_Destroy(src) end

---@param src PCM_source
---@param peakrate number
---@param starttime number
---@param numchannels integer
---@param numsamplesperchannel integer
---@param want_extra_type integer
---@param buf ReaperArray
---@return integer
--- Gets block of peak samples to buf. Note that the peak samples are interleaved, but in two or three blocks (maximums, then minimums, then extra). Return value has 20 bits of returned sample count, then 4 bits of output_mode (0xf00000), then a bit to signify whether extra_type was available (0x1000000). extra_type can be 115 ('s') for spectral information, which will return peak samples as integers with the low 15 bits frequency, next 14 bits tonality.
function reaper.PCM_Source_GetPeaks(src, peakrate, starttime, numchannels, numsamplesperchannel, want_extra_type, buf) end

---@param src PCM_source
---@return boolean retval, number offs, number len, boolean rev
--- If a section/reverse block, retrieves offset/len/reverse. return true if success
function reaper.PCM_Source_GetSectionInfo(src) end

---@param amt integer
function reaper.PluginWantsAlwaysRunFx(amt) end

---@param prevent_count integer
--- adds prevent_count to the UI refresh prevention state; always add then remove the same amount, or major disfunction will occur
function reaper.PreventUIRefresh(prevent_count) end

---@param session_mode integer
---@param init_id integer
---@param section_id integer
---@return integer
--- Uses the action list to choose an action. Call with session_mode=1 to create a session (init_id will be the initial action to select, or 0), then poll with session_mode=0, checking return value for user-selected action (will return 0 if no action selected yet, or -1 if the action window is no longer available). When finished, call with session_mode=-1.
function reaper.PromptForAction(session_mode, init_id, section_id) end

---@param errmsg string
--- Causes REAPER to display the error message after the current ReaScript finishes. If called within a Lua context and errmsg has a ! prefix, script execution will be terminated.
function reaper.ReaScriptError(errmsg) end

---@param path string
---@param ignored integer
---@return integer
--- returns positive value on success, 0 on failure.
function reaper.RecursiveCreateDirectory(path, ignored) end

---@param flags integer
---@return integer
--- garbage-collects extra open files and closes them. if flags has 1 set, this is done incrementally (call this from a regular timer, if desired). if flags has 2 set, files are aggressively closed (they may need to be re-opened very soon). returns number of files closed by this call.
function reaper.reduce_open_files(flags) end

---@param command_id integer
--- See RefreshToolbar2.
function reaper.RefreshToolbar(command_id) end

---@param section_id integer
---@param command_id integer
--- Refresh the toolbar button states of a toggle action.
function reaper.RefreshToolbar2(section_id, command_id) end

---@param in_ string
---@param out string
---@return string out
--- Makes a filename "in" relative to the current project, if any.
function reaper.relative_fn(in_, out) end

---@param tr MediaTrack
---@param category integer
---@param sendidx integer
---@return boolean
--- Remove a send/receive/hardware output, return true on success. category is 0 for hardware outputs. See CreateTrackSend , GetSetTrackSendInfo , GetTrackSendInfo_Value , SetTrackSendInfo_Value , GetTrackNumSends.
function reaper.RemoveTrackSend(tr, category, sendidx) end

---@param source_filename string
---@param target_filename string
---@param start_percent number
---@param end_percent number
---@param playrate number
---@return boolean
--- Not available while playing back.
function reaper.RenderFileSection(source_filename, target_filename, start_percent, end_percent, playrate) end

---@param beforeTrackIdx integer
---@param makePrevFolder integer
---@return boolean
--- Moves all selected tracks to immediately above track specified by index beforeTrackIdx, returns false if no tracks were selected. makePrevFolder=0 for normal, 1 = as child of track preceding track specified by beforeTrackIdx, 2 = if track preceding track specified by beforeTrackIdx is last track in folder, extend folder
function reaper.ReorderSelectedTracks(beforeTrackIdx, makePrevFolder) end

---@param mode integer
---@return string
function reaper.Resample_EnumModes(mode) end

---@param in_ string
---@param out string
---@return string out
--- See resolve_fn2.
function reaper.resolve_fn(in_, out) end

---@param in_ string
---@param out string
---@param checkSubDir optional string
---@return string out
--- Resolves a filename "in" by using project settings etc. If no file found, out will be a copy of in.
function reaper.resolve_fn2(in_, out, checkSubDir) end

---@param project ReaProject
---@param timePosition number
---@param wildcards string
---@param resolvedString string
---@return string resolvedString
--- Resolve a wildcard string. Any wildcards that are valid in the Big Clock can be resolved using this function. Pass in timePosition=-1 to use the current project playback position.
function reaper.ResolveWildcards(project, timePosition, wildcards, resolvedString) end

---@param command_id integer
---@return string
--- Get the named command for the given command ID. The returned string will not start with '_' (e.g. it will return "SWS_ABOUT"), it will be NULL if command_id is a native action.
function reaper.ReverseNamedCommandLookup(command_id) end

---@param scaling_mode integer
---@param val number
---@return number
--- See GetEnvelopeScalingMode.
function reaper.ScaleFromEnvelopeMode(scaling_mode, val) end

---@param scaling_mode integer
---@param val number
---@return number
--- See GetEnvelopeScalingMode.
function reaper.ScaleToEnvelopeMode(scaling_mode, val) end

---@param uniqueID integer
---@return KbdSectionInfo
function reaper.SectionFromUniqueID(uniqueID) end

---@param proj ReaProject
---@param selected boolean
function reaper.SelectAllMediaItems(proj, selected) end

---@param proj ReaProject
function reaper.SelectProjectInstance(proj) end

---@param output integer
---@param msg string
--- Sends a MIDI message to output device specified by output. Message is sent in immediate mode. Lua example of how to pack the message string: sysex = { 0xF0, 0x00, 0xF7 } msg = "" for i=1, #sysex do msg = msg .. string.char(sysex[i]) end
function reaper.SendMIDIMessageToHardware(output, msg) end

---@param take MediaItem_Take
--- set this take active in this media item
function reaper.SetActiveTake(take) end

---@param mode integer
---@param onlySel boolean
--- sets all or selected tracks to mode.
function reaper.SetAutomationMode(mode, onlySel) end

---@param __proj ReaProject
---@param bpm number
---@param wantUndo boolean
--- set current BPM in project, set wantUndo=true to add undo point
function reaper.SetCurrentBPM(__proj, bpm, wantUndo) end

---@param mode integer
---@param envIn TrackEnvelope
--- You must use this to change the focus programmatically. mode=0 to focus track panels, 1 to focus the arrange window, 2 to focus the arrange window and select env (or env==NULL to clear the current track/take envelope selection)
function reaper.SetCursorContext(mode, envIn) end

---@param time number
---@param moveview boolean
---@param seekplay boolean
function reaper.SetEditCurPos(time, moveview, seekplay) end

---@param proj ReaProject
---@param time number
---@param moveview boolean
---@param seekplay boolean
function reaper.SetEditCurPos2(proj, time, moveview, seekplay) end

---@param envelope TrackEnvelope
---@param ptidx integer
---@param timeIn optional number
---@param valueIn optional number
---@param shapeIn optional integer
---@param tensionIn optional number
---@param selectedIn optional boolean
---@param noSortIn optional boolean
---@return boolean
--- Set attributes of an envelope point. Values that are not supplied will be ignored. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. See SetEnvelopePointEx.
function reaper.SetEnvelopePoint(envelope, ptidx, timeIn, valueIn, shapeIn, tensionIn, selectedIn, noSortIn) end

---@param envelope TrackEnvelope
---@param autoitem_idx integer
---@param ptidx integer
---@param timeIn optional number
---@param valueIn optional number
---@param shapeIn optional integer
---@param tensionIn optional number
---@param selectedIn optional boolean
---@param noSortIn optional boolean
---@return boolean
--- Set attributes of an envelope point. Values that are not supplied will be ignored. If setting multiple points at once, set noSort=true, and call Envelope_SortPoints when done. autoitem_idx=-1 for the underlying envelope, 0 for the first automation item on the envelope, etc. For automation items, pass autoitem_idx|0x10000000 to base ptidx on the number of points in one full loop iteration, even if the automation item is trimmed so that not all points are visible. Otherwise, ptidx will be based on the number of visible points in the automation item, including all loop iterations. See CountEnvelopePointsEx , GetEnvelopePointEx , InsertEnvelopePointEx , DeleteEnvelopePointEx.
function reaper.SetEnvelopePointEx(envelope, autoitem_idx, ptidx, timeIn, valueIn, shapeIn, tensionIn, selectedIn,
                                   noSortIn)
end

---@param env TrackEnvelope
---@param str string
---@param isundo boolean
---@return boolean
--- Sets the RPPXML state of an envelope, returns true if successful. Undo flag is a performance/caching hint.
function reaper.SetEnvelopeStateChunk(env, str, isundo) end

---@param section string
---@param key string
---@param value string
---@param persist boolean
--- Set the extended state value for a specific section and key. persist=true means the value should be stored and reloaded the next time REAPER is opened. See GetExtState , DeleteExtState , HasExtState.
function reaper.SetExtState(section, key, value, persist) end

---@param mode integer
--- mode: see GetGlobalAutomationOverride
function reaper.SetGlobalAutomationOverride(mode) end

---@param item MediaItem
---@param str string
---@param isundo boolean
---@return boolean
--- Sets the RPPXML state of an item, returns true if successful. Undo flag is a performance/caching hint.
function reaper.SetItemStateChunk(item, str, isundo) end

---@param flag integer
---@return integer
--- set &1 to show the master track in the TCP, &2 to HIDE in the mixer. Returns the previous visibility state. See GetMasterTrackVisibility.
function reaper.SetMasterTrackVisibility(flag) end

---@param item MediaItem
---@param parmname string
---@param newvalue number
---@return boolean
--- Set media item numerical-value attributes. B_MUTE : bool * : muted (item solo overrides). setting this value will clear C_MUTE_SOLO. B_MUTE_ACTUAL : bool * : muted (ignores solo). setting this value will not affect C_MUTE_SOLO. C_LANEPLAYS : char * : on fixed lane tracks, 0=this item lane does not play, 1=this item lane plays exclusively, 2=this item lane plays and other lanes also play, -1=this item is on a non-visible, non-playing lane on a formerly fixed-lane track (read-only) C_MUTE_SOLO : char * : solo override (-1=soloed, 0=no override, 1=unsoloed). note that this API does not automatically unsolo other items when soloing (nor clear the unsolos when clearing the last soloed item), it must be done by the caller via action or via this API. B_LOOPSRC : bool * : loop source B_ALLTAKESPLAY : bool * : all takes play B_UISEL : bool * : selected in arrange view C_BEATATTACHMODE : char * : item timebase, -1=track or project default, 1=beats (position, length, rate), 2=beats (position only). for auto-stretch timebase: C_BEATATTACHMODE=1, C_AUTOSTRETCH=1 C_AUTOSTRETCH: : char * : auto-stretch at project tempo changes, 1=enabled, requires C_BEATATTACHMODE=1 C_LOCK : char * : locked, &1=locked D_VOL : double * : item volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc D_POSITION : double * : item position in seconds D_LENGTH : double * : item length in seconds D_SNAPOFFSET : double * : item snap offset in seconds D_FADEINLEN : double * : item manual fadein length in seconds D_FADEOUTLEN : double * : item manual fadeout length in seconds D_FADEINDIR : double * : item fadein curvature, -1..1 D_FADEOUTDIR : double * : item fadeout curvature, -1..1 D_FADEINLEN_AUTO : double * : item auto-fadein length in seconds, -1=no auto-fadein D_FADEOUTLEN_AUTO : double * : item auto-fadeout length in seconds, -1=no auto-fadeout C_FADEINSHAPE : int * : fadein shape, 0..6, 0=linear C_FADEOUTSHAPE : int * : fadeout shape, 0..6, 0=linear I_GROUPID : int * : group ID, 0=no group I_LASTY : int * : Y-position (relative to top of track) in pixels (read-only) I_LASTH : int * : height in pixels (read-only) I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color I_CURTAKE : int * : active take number IP_ITEMNUMBER : int : item number on this track (read-only, returns the item number directly) F_FREEMODE_Y : float * : free item positioning or fixed lane Y-position. 0=top of track, 1.0=bottom of track F_FREEMODE_H : float * : free item positioning or fixed lane height. 0.5=half the track height, 1.0=full track height I_FIXEDLANE : int * : fixed lane of item (fine to call with setNewValue, but returned value is read-only) B_FIXEDLANE_HIDDEN : bool * : true if displaying only one fixed lane and this item is in a different lane (read-only)
function reaper.SetMediaItemInfo_Value(item, parmname, newvalue) end

---@param item MediaItem
---@param length number
---@param refreshUI boolean
---@return boolean
--- Redraws the screen only if refreshUI == true. See UpdateArrange ().
function reaper.SetMediaItemLength(item, length, refreshUI) end

---@param item MediaItem
---@param position number
---@param refreshUI boolean
---@return boolean
--- Redraws the screen only if refreshUI == true. See UpdateArrange ().
function reaper.SetMediaItemPosition(item, position, refreshUI) end

---@param item MediaItem
---@param selected boolean
function reaper.SetMediaItemSelected(item, selected) end

---@param take MediaItem_Take
---@param source PCM_source
---@return boolean
--- Set media source of media item take. The old source will not be destroyed, it is the caller's responsibility to retrieve it and destroy it after. If source already exists in any project, it will be duplicated before being set. C/C++ code should not use this and instead use GetSetMediaItemTakeInfo() with P_SOURCE to manage ownership directly.
function reaper.SetMediaItemTake_Source(take, source) end

---@param take MediaItem_Take
---@param parmname string
---@param newvalue number
---@return boolean
--- Set media item take numerical-value attributes. D_STARTOFFS : double * : start offset in source media, in seconds D_VOL : double * : take volume, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc, negative if take polarity is flipped D_PAN : double * : take pan, -1..1 D_PANLAW : double * : take pan law, -1=default, 0.5=-6dB, 1.0=+0dB, etc D_PLAYRATE : double * : take playback rate, 0.5=half speed, 1=normal, 2=double speed, etc D_PITCH : double * : take pitch adjustment in semitones, -12=one octave down, 0=normal, +12=one octave up, etc B_PPITCH : bool * : preserve pitch when changing playback rate I_LASTY : int * : Y-position (relative to top of track) in pixels (read-only) I_LASTH : int * : height in pixels (read-only) I_CHANMODE : int * : channel mode, 0=normal, 1=reverse stereo, 2=downmix, 3=left, 4=right I_PITCHMODE : int * : pitch shifter mode, -1=project default, otherwise high 2 bytes=shifter, low 2 bytes=parameter I_STRETCHFLAGS : int * : stretch marker flags (&7 mask for mode override: 0=default, 1=balanced, 2/3/6=tonal, 4=transient, 5=no pre-echo) F_STRETCHFADESIZE : float * : stretch marker fade size in seconds (0.0025 default) I_RECPASSID : int * : record pass ID I_TAKEFX_NCH : int * : number of internal audio channels for per-take FX to use (OK to call with setNewValue, but the returned value is read-only) I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color IP_SPECEDIT:CNT : int : spectral edit count (read-only) IP_SPECEDIT:DELETE:x : int : read or write this key to remove the spectral edit specified IP_SPECEDIT:ADD : int : read or write this key to add a new spectral edit (returns index) IP_SPECEDIT:SORT : int : read or write this key to re-sort spectral edits (be sure to do this following a position change or insert of new edit) I_SPECEDIT:FFT_SIZE : int * : FFT size used by spectral edits for this take D_SPECEDIT:x:POSITION : double * : position of spectral edit start (changing this requires a resort of spectral edits) D_SPECEDIT:x:LENGTH : double * : length of spectral edit F_SPECEDIT:x:GAIN : float * : gain of spectral edit F_SPECEDIT:x:FADE_IN : float * : fade-in size 0..1 F_SPECEDIT:x:FADE_OUT : float * : fade-out size 0..1 F_SPECEDIT:x:FADE_LOW : float * : fade-lf size 0..1 F_SPECEDIT:x:FADE_HI : float * : fade-hf size 0..1 I_SPECEDIT:x:CHAN : int * : channel index, -1 for omni I_SPECEDIT:x:FLAGS : int * : flags, &1=bypassed, &2=solo F_SPECEDIT:x:GATE_THRESH : float * : gate threshold F_SPECEDIT:x:GATE_FLOOR : float * : gate floor F_SPECEDIT:x:COMP_THRESH : float * : comp threshold F_SPECEDIT:x:COMP_RATIO : float * : comp ratio B_SPECEDIT:x:SELECTED : bool * : selection state I_SPECEDIT:x:TOPFREQ_CNT : int * : (read-only) number of top frequency-points I_SPECEDIT:x:TOPFREQ_ADD:pos:val : int * : reading or writing will insert top frequency-point with position/value pair, returns index I_SPECEDIT:x:TOPFREQ_DEL:y : int * : reading or writing will delete top frequency-point y. there will always be at least one point. F_SPECEDIT:x:TOPFREQ_POS:y : float * : (read-only) get position of top frequency-point y F_SPECEDIT:x:TOPFREQ_FREQ:y : float * : (read-only) get frequency of top frequency-point y I_SPECEDIT:x:BOTFREQ_CNT : int * : number of bottom frequency-points I_SPECEDIT:x:BOTFREQ_ADD:pos:val : int * : reading or writing will insert bottom frequency-point with position/value pair, returns index I_SPECEDIT:x:BOTFREQ_DEL:y : int * : reading or writing will delete bottom frequency-point y. there will always be at least one point. F_SPECEDIT:x:BOTFREQ_POS:y : float * : (read-only) get position of bottom frequency-point y F_SPECEDIT:x:BOTFREQ_FREQ:y : float * : (read-only) get frequency of bottom frequency-point y IP_TAKENUMBER : int : take number (read-only, returns the take number directly)
function reaper.SetMediaItemTakeInfo_Value(take, parmname, newvalue) end

---@param tr MediaTrack
---@param parmname string
---@param newvalue number
---@return boolean
--- Set track numerical-value attributes. B_MUTE : bool * : muted B_PHASE : bool * : track phase inverted B_RECMON_IN_EFFECT : bool * : record monitoring in effect (current audio-thread playback state, read-only) IP_TRACKNUMBER : int : track number 1-based, 0=not found, -1=master track (read-only, returns the int directly) I_SOLO : int * : soloed, 0=not soloed, 1=soloed, 2=soloed in place, 5=safe soloed, 6=safe soloed in place B_SOLO_DEFEAT : bool * : when set, if anything else is soloed and this track is not muted, this track acts soloed I_FXEN : int * : fx enabled, 0=bypassed, !0=fx active I_RECARM : int * : record armed, 0=not record armed, 1=record armed I_RECINPUT : int * : record input, <0=no input. if 4096 set, input is MIDI and low 5 bits represent channel (0=all, 1-16=only chan), next 6 bits represent physical input (63=all, 62=VKB). If 4096 is not set, low 10 bits (0..1023) are input start channel (ReaRoute/Loopback start at 512). If 2048 is set, input is multichannel input (using track channel count), or if 1024 is set, input is stereo input, otherwise input is mono. I_RECMODE : int * : record mode, 0=input, 1=stereo out, 2=none, 3=stereo out w/latency compensation, 4=midi output, 5=mono out, 6=mono out w/ latency compensation, 7=midi overdub, 8=midi replace I_RECMODE_FLAGS : int * : record mode flags, &3=output recording mode (0=post fader, 1=pre-fx, 2=post-fx/pre-fader) I_RECMON : int * : record monitoring, 0=off, 1=normal, 2=not when playing (tape style) I_RECMONITEMS : int * : monitor items while recording, 0=off, 1=on B_AUTO_RECARM : bool * : automatically set record arm when selected (does not immediately affect recarm state, script should set directly if desired) I_VUMODE : int * : track vu mode, &1:disabled, &30==0:stereo peaks, &30==2:multichannel peaks, &30==4:stereo RMS, &30==8:combined RMS, &30==12:LUFS-M, &30==16:LUFS-S (readout=max), &30==20:LUFS-S (readout=current), &32:LUFS calculation on channels 1+2 only I_AUTOMODE : int * : track automation mode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch I_NCHAN : int * : number of track channels, 2-128, even numbers only I_SELECTED : int * : track selected, 0=unselected, 1=selected I_WNDH : int * : current TCP window height in pixels including envelopes (read-only) I_TCPH : int * : current TCP window height in pixels not including envelopes (read-only) I_TCPY : int * : current TCP window Y-position in pixels relative to top of arrange view (read-only) I_MCPX : int * : current MCP X-position in pixels relative to mixer container (read-only) I_MCPY : int * : current MCP Y-position in pixels relative to mixer container (read-only) I_MCPW : int * : current MCP width in pixels (read-only) I_MCPH : int * : current MCP height in pixels (read-only) I_FOLDERDEPTH : int * : folder depth change, 0=normal, 1=track is a folder parent, -1=track is the last in the innermost folder, -2=track is the last in the innermost and next-innermost folders, etc I_FOLDERCOMPACT : int * : folder collapsed state (only valid on folders), 0=normal, 1=collapsed, 2=fully collapsed I_MIDIHWOUT : int * : track midi hardware output index, <0=disabled, low 5 bits are which channels (0=all, 1-16), next 5 bits are output device index (0-31) I_MIDI_INPUT_CHANMAP : int * : -1 maps to source channel, otherwise 1-16 to map to MIDI channel I_MIDI_CTL_CHAN : int * : -1 no link, 0-15 link to MIDI volume/pan on channel, 16 link to MIDI volume/pan on all channels I_MIDI_TRACKSEL_FLAG : int * : MIDI editor track list options: &1=expand media items, &2=exclude from list, &4=auto-pruned I_PERFFLAGS : int * : track performance flags, &1=no media buffering, &2=no anticipative FX I_CUSTOMCOLOR : int * : custom color, OS dependent color|0x1000000 (i.e. ColorToNative(r,g,b)|0x1000000). If you do not |0x1000000, then it will not be used, but will store the color I_HEIGHTOVERRIDE : int * : custom height override for TCP window, 0 for none, otherwise size in pixels I_SPACER : int * : 1=TCP track spacer above this trackB_HEIGHTLOCK : bool * : track height lock (must set I_HEIGHTOVERRIDE before locking) D_VOL : double * : trim volume of track, 0=-inf, 0.5=-6dB, 1=+0dB, 2=+6dB, etc D_PAN : double * : trim pan of track, -1..1 D_WIDTH : double * : width of track, -1..1 D_DUALPANL : double * : dualpan position 1, -1..1, only if I_PANMODE==6 D_DUALPANR : double * : dualpan position 2, -1..1, only if I_PANMODE==6 I_PANMODE : int * : pan mode, 0=classic 3.x, 3=new balance, 5=stereo pan, 6=dual pan D_PANLAW : double * : pan law of track, <0=project default, 0.5=-6dB, 0.707..=-3dB, 1=+0dB, 1.414..=-3dB with gain compensation, 2=-6dB with gain compensation, etc I_PANLAW_FLAGS : int * : pan law flags, 0=sine taper, 1=hybrid taper with deprecated behavior when gain compensation enabled, 2=linear taper, 3=hybrid taper P_ENV:<envchunkname or P_ENV:{GUID... : TrackEnvelope * : (read-only) chunkname can be <VOLENV, <PANENV, etc; GUID is the stringified envelope GUID. B_SHOWINMIXER : bool * : track control panel visible in mixer (do not use on master track) B_SHOWINTCP : bool * : track control panel visible in arrange view (do not use on master track) B_MAINSEND : bool * : track sends audio to parent C_MAINSEND_OFFS : char * : channel offset of track send to parent C_MAINSEND_NCH : char * : channel count of track send to parent (0=use all child track channels, 1=use one channel only) I_FREEMODE : int * : 1=track free item positioning enabled, 2=track fixed lanes enabled (call UpdateTimeline() after changing) I_NUMFIXEDLANES : int * : number of track fixed lanes (fine to call with setNewValue, but returned value is read-only) C_LANESCOLLAPSED : char * : fixed lane collapse state (1=lanes collapsed, 2=track displays as non-fixed-lanes but hidden lanes exist) C_LANESETTINGS : char * : fixed lane settings (&1=auto-remove empty lanes at bottom, &2=do not auto-comp new recording, &4=newly recorded lanes play exclusively (else add lanes in layers), &8=big lanes (else small lanes), &16=add new recording at bottom (else record into first available lane), &32=hide lane buttons C_LANEPLAYS:N : char * : on fixed lane tracks, 0=lane N does not play, 1=lane N plays exclusively, 2=lane N plays and other lanes also play (fine to call with setNewValue, but returned value is read-only) C_ALLLANESPLAY : char * : on fixed lane tracks, 0=no lanes play, 1=all lanes play, 2=some lanes play (fine to call with setNewValue 0 or 1, but returned value is read-only) C_BEATATTACHMODE : char * : track timebase, -1=project default, 0=time, 1=beats (position, length, rate), 2=beats (position only) F_MCP_FXSEND_SCALE : float * : scale of fx+send area in MCP (0=minimum allowed, 1=maximum allowed) F_MCP_FXPARM_SCALE : float * : scale of fx parameter area in MCP (0=minimum allowed, 1=maximum allowed) F_MCP_SENDRGN_SCALE : float * : scale of send area as proportion of the fx+send total area (0=minimum allowed, 1=maximum allowed) F_TCP_FXPARM_SCALE : float * : scale of TCP parameter area when TCP FX are embedded (0=min allowed, default, 1=max allowed) I_PLAY_OFFSET_FLAG : int * : track media playback offset state, &1=bypassed, &2=offset value is measured in samples (otherwise measured in seconds) D_PLAY_OFFSET : double * : track media playback offset, units depend on I_PLAY_OFFSET_FLAG
function reaper.SetMediaTrackInfo_Value(tr, parmname, newvalue) end

---@param project ReaProject
---@param division number
--- Set the MIDI editor grid division. 0.25=quarter note, 1.0/3.0=half note tripet, etc.
function reaper.SetMIDIEditorGrid(project, division) end

---@param leftmosttrack MediaTrack
---@return MediaTrack
--- Scroll the mixer so that leftmosttrack is the leftmost visible track. Returns the leftmost track after scrolling, which may be different from the passed-in track if there are not enough tracks to its right.
function reaper.SetMixerScroll(leftmosttrack) end

---@param context string
---@param modifier_flag integer
---@param action string
--- Set the mouse modifier assignment for a specific modifier key assignment, in a specific context. Context is a string like "MM_CTX_ITEM" (see reaper-mouse.ini) or "Media item left drag" (unlocalized). Modifier flag is a number from 0 to 15: add 1 for shift, 2 for control, 4 for alt, 8 for win. (macOS: add 1 for shift, 2 for command, 4 for opt, 8 for control.) For left-click and double-click contexts, the action can be any built-in command ID number or any custom action ID string. Find built-in command IDs in the REAPER actions window (enable "show command IDs" in the context menu), and find custom action ID strings in reaper-kb.ini. The action string may be a mouse modifier ID (see reaper-mouse.ini) with " m" appended to it, or (for click/double-click contexts) a command ID with " c" appended to it, or the text that appears in the mouse modifiers preferences dialog, like "Move item" (unlocalized). For example, SetMouseModifier("MM_CTX_ITEM", 0, "1 m") and SetMouseModifier("Media item left drag", 0, "Move item") are equivalent. SetMouseModifier(context, modifier_flag, -1) will reset that mouse modifier to default. SetMouseModifier(context, -1, -1) will reset the entire context to default. SetMouseModifier(-1, -1, -1) will reset all contexts to default. See GetMouseModifier.
function reaper.SetMouseModifier(context, modifier_flag, action) end

---@param track MediaTrack
--- Set exactly one track selected, deselect all others
function reaper.SetOnlyTrackSelected(track) end

---@param project ReaProject
---@param division number
--- Set the arrange view grid division. 0.25=quarter note, 1.0/3.0=half note triplet, etc.
function reaper.SetProjectGrid(project, division) end

---@param markrgnindexnumber integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@return boolean
--- Note: this function can't clear a marker's name (an empty string will leave the name unchanged), see SetProjectMarker4.
function reaper.SetProjectMarker(markrgnindexnumber, isrgn, pos, rgnend, name) end

---@param proj ReaProject
---@param markrgnindexnumber integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@return boolean
--- Note: this function can't clear a marker's name (an empty string will leave the name unchanged), see SetProjectMarker4.
function reaper.SetProjectMarker2(proj, markrgnindexnumber, isrgn, pos, rgnend, name) end

---@param proj ReaProject
---@param markrgnindexnumber integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param color integer
---@return boolean
--- Note: this function can't clear a marker's name (an empty string will leave the name unchanged), see SetProjectMarker4.
function reaper.SetProjectMarker3(proj, markrgnindexnumber, isrgn, pos, rgnend, name, color) end

---@param proj ReaProject
---@param markrgnindexnumber integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param name string
---@param color integer
---@param flags integer
---@return boolean
--- color should be 0 to not change, or ColorToNative(r,g,b)|0x1000000, flags&1 to clear name
function reaper.SetProjectMarker4(proj, markrgnindexnumber, isrgn, pos, rgnend, name, color, flags) end

---@param proj ReaProject
---@param markrgnidx integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param IDnumber integer
---@param name string
---@param color integer
---@return boolean
--- See SetProjectMarkerByIndex2.
function reaper.SetProjectMarkerByIndex(proj, markrgnidx, isrgn, pos, rgnend, IDnumber, name, color) end

---@param proj ReaProject
---@param markrgnidx integer
---@param isrgn boolean
---@param pos number
---@param rgnend number
---@param IDnumber integer
---@param name string
---@param color integer
---@param flags integer
---@return boolean
--- Differs from SetProjectMarker4 in that markrgnidx is 0 for the first marker/region, 1 for the next, etc (see EnumProjectMarkers3 ), rather than representing the displayed marker/region ID number (see SetProjectMarker3 ). IDnumber < 0 to ignore. Function will fail if attempting to set a duplicate ID number for a region (duplicate ID numbers for markers are OK). flags&1 to clear name. If flags&2, markers will not be re-sorted, and after making updates, you MUST call SetProjectMarkerByIndex2 with markrgnidx=-1 and flags&2 to force re-sort/UI updates.
function reaper.SetProjectMarkerByIndex2(proj, markrgnidx, isrgn, pos, rgnend, IDnumber, name, color, flags) end

---@param proj ReaProject
---@param extname string
---@param key string
---@param value string
---@return integer
--- Save a key/value pair for a specific extension, to be restored the next time this specific project is loaded. Typically extname will be the name of a reascript or extension section. If key is NULL or "", all extended data for that extname will be deleted. If val is NULL or "", the data previously associated with that key will be deleted. Returns the size of the state for this extname. See GetProjExtState , EnumProjExtState.
function reaper.SetProjExtState(proj, extname, key, value) end

---@param proj ReaProject
---@param regionindex integer
---@param track MediaTrack
---@param flag integer
--- Add (flag > 0) or remove (flag < 0) a track from this region when using the region render matrix. If adding, flag==2 means force mono, flag==4 means force stereo, flag==N means force N/2 channels.
function reaper.SetRegionRenderMatrix(proj, regionindex, track, flag) end

---@param take MediaItem_Take
---@param idx integer
---@param nameIn string
---@param srcposIn optional number
---@param colorIn optional integer
---@return integer
--- Inserts or updates a take marker. If idx<0, a take marker will be added, otherwise an existing take marker will be updated. Returns the index of the new or updated take marker (which may change if srcPos is updated). See GetNumTakeMarkers , GetTakeMarker , DeleteTakeMarker
function reaper.SetTakeMarker(take, idx, nameIn, srcposIn, colorIn) end

---@param take MediaItem_Take
---@param idx integer
---@param pos number
---@param srcposIn optional number
---@return integer
--- Adds or updates a stretch marker. If idx=0, stretch marker will be updated. When adding, if srcposInOptional is omitted, source position will be auto-calculated. When updating a stretch marker, if srcposInOptional is omitted, srcpos will not be modified. Position/srcposition values will be constrained to nearby stretch markers. Returns index of stretch marker, or -1 if did not insert (or marker already existed at time).
function reaper.SetTakeStretchMarker(take, idx, pos, srcposIn) end

---@param take MediaItem_Take
---@param idx integer
---@param slope number
---@return boolean
--- See GetTakeStretchMarkerSlope
function reaper.SetTakeStretchMarkerSlope(take, idx, slope) end

---@param proj ReaProject
---@param ptidx integer
---@param timepos number
---@param measurepos integer
---@param beatpos number
---@param bpm number
---@param timesig_num integer
---@param timesig_denom integer
---@param lineartempo boolean
---@return boolean
--- Set parameters of a tempo/time signature marker. Provide either timepos (with measurepos=-1, beatpos=-1), or measurepos and beatpos (with timepos=-1). If timesig_num and timesig_denom are zero, the previous time signature will be used. ptidx=-1 will insert a new tempo/time signature marker. See CountTempoTimeSigMarkers , GetTempoTimeSigMarker , AddTempoTimeSigMarker.
function reaper.SetTempoTimeSigMarker(proj, ptidx, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom,
                                      lineartempo)
end

---@param ini_key string
---@param color integer
---@param flags integer
---@return integer
--- Temporarily updates the theme color to the color specified (or the theme default color if -1 is specified). Returns -1 on failure, otherwise returns the color (or transformed-color). Note that the UI is not updated by this, the caller should call UpdateArrange() etc as necessary. If the low bit of flags is set, any color transformations are bypassed. To read a value see GetThemeColor . Currently valid ini_keys: col_main_bg2 : Main window/transport background -- current RGB: 0,0,0 col_main_text2 : Main window/transport text -- current RGB: 0,0,0 col_main_textshadow : Main window text shadow (ignored if too close to text color) -- current RGB: 0,0,0 col_main_3dhl : Main window 3D highlight -- current RGB: 0,0,0 col_main_3dsh : Main window 3D shadow -- current RGB: 0,0,0 col_main_resize2 : Main window pane resize mouseover -- current RGB: 0,0,0 col_main_text : Themed window text -- current RGB: 0,0,0 col_main_bg : Themed window background -- current RGB: 0,0,0 col_main_editbk : Themed window edit background -- current RGB: 0,0,0 col_nodarkmodemiscwnd : Do not use window theming on macOS dark mode -- bool 00000000 col_transport_editbk : Transport edit background -- current RGB: 0,0,0 col_toolbar_text : Toolbar button text -- current RGB: 0,0,0 col_toolbar_text_on : Toolbar button enabled text -- current RGB: 0,0,0 col_toolbar_frame : Toolbar frame when floating or docked -- current RGB: 0,0,0 toolbararmed_color : Toolbar button armed color -- current RGB: 0,0,0 toolbararmed_drawmode : Toolbar button armed fill mode -- blendmode 00000000 io_text : I/O window text -- current RGB: 0,0,0 io_3dhl : I/O window 3D highlight -- current RGB: 0,0,0 io_3dsh : I/O window 3D shadow -- current RGB: 0,0,0 genlist_bg : Window list background -- current RGB: 0,0,0 genlist_fg : Window list text -- current RGB: 0,0,0 genlist_grid : Window list grid lines -- current RGB: 0,0,0 genlist_selbg : Window list selected row -- current RGB: 0,0,0 genlist_selfg : Window list selected text -- current RGB: 0,0,0 genlist_seliabg : Window list selected row (inactive) -- current RGB: 0,0,0 genlist_seliafg : Window list selected text (inactive) -- current RGB: 0,0,0 genlist_hilite : Window list highlighted text -- current RGB: 0,0,0 genlist_hilite_sel : Window list highlighted selected text -- current RGB: 0,0,0 col_buttonbg : Button background -- current RGB: 0,0,0 col_tcp_text : Track panel text -- current RGB: 0,0,0 col_tcp_textsel : Track panel (selected) text -- current RGB: 0,0,0 col_seltrack : Selected track control panel background -- current RGB: 0,0,0 col_seltrack2 : Unselected track control panel background (enabled with a checkbox above) -- current RGB: 0,0,0 tcplocked_color : Locked track control panel overlay color -- current RGB: 0,0,0 tcplocked_drawmode : Locked track control panel fill mode -- blendmode 00000000 col_tracklistbg : Empty track list area -- current RGB: 0,0,0 col_mixerbg : Empty mixer list area -- current RGB: 0,0,0 col_arrangebg : Empty arrange view area -- current RGB: 0,0,0 arrange_vgrid : Empty arrange view area vertical grid shading -- current RGB: 0,0,0 col_fadearm : Fader background when automation recording -- current RGB: 0,0,0 col_fadearm2 : Fader background when automation playing -- current RGB: 0,0,0 col_fadearm3 : Fader background when in inactive touch/latch -- current RGB: 0,0,0 col_tl_fg : Timeline foreground -- current RGB: 0,0,0 col_tl_fg2 : Timeline foreground (secondary markings) -- current RGB: 0,0,0 col_tl_bg : Timeline background -- current RGB: 0,0,0 col_tl_bgsel : Time selection color -- current RGB: 0,0,0 timesel_drawmode : Time selection fill mode -- blendmode 00000000 col_tl_bgsel2 : Timeline background (in loop points) -- current RGB: 0,0,0 col_trans_bg : Transport status background -- current RGB: 0,0,0 col_trans_fg : Transport status text -- current RGB: 0,0,0 playrate_edited : Project play rate control when not 1.0 -- current RGB: 0,0,0 selitem_dot : Media item selection indicator -- current RGB: 0,0,0 col_mi_label : Media item label -- current RGB: 0,0,0 col_mi_label_sel : Media item label (selected) -- current RGB: 0,0,0 col_mi_label_float : Floating media item label -- current RGB: 0,0,0 col_mi_label_float_sel : Floating media item label (selected) -- current RGB: 0,0,0 col_mi_bg2 : Media item background (odd tracks) -- current RGB: 0,0,0 col_mi_bg : Media item background (even tracks) -- current RGB: 0,0,0 col_tr1_itembgsel : Media item background selected (odd tracks) -- current RGB: 0,0,0 col_tr2_itembgsel : Media item background selected (even tracks) -- current RGB: 0,0,0 itembg_drawmode : Media item background fill mode -- blendmode 00000000 col_tr1_peaks : Media item peaks (odd tracks) -- current RGB: 0,0,0 col_tr2_peaks : Media item peaks (even tracks) -- current RGB: 0,0,0 col_tr1_ps2 : Media item peaks when selected (odd tracks) -- current RGB: 0,0,0 col_tr2_ps2 : Media item peaks when selected (even tracks) -- current RGB: 0,0,0 col_peaksedge : Media item peaks edge highlight (odd tracks) -- current RGB: 0,0,0 col_peaksedge2 : Media item peaks edge highlight (even tracks) -- current RGB: 0,0,0 col_peaksedgesel : Media item peaks edge highlight when selected (odd tracks) -- current RGB: 0,0,0 col_peaksedgesel2 : Media item peaks edge highlight when selected (even tracks) -- current RGB: 0,0,0 cc_chase_drawmode : Media item MIDI CC peaks fill mode -- blendmode 00000000 col_peaksfade : Media item peaks when active in crossfade editor (fade-out) -- current RGB: 0,0,0 col_peaksfade2 : Media item peaks when active in crossfade editor (fade-in) -- current RGB: 0,0,0 col_mi_fades : Media item fade/volume controls -- current RGB: 0,0,0 fadezone_color : Media item fade quiet zone fill color -- current RGB: 0,0,0 fadezone_drawmode : Media item fade quiet zone fill mode -- blendmode 00000000 fadearea_color : Media item fade full area fill color -- current RGB: 0,0,0 fadearea_drawmode : Media item fade full area fill mode -- blendmode 00000000 col_mi_fade2 : Media item edges of controls -- current RGB: 0,0,0 col_mi_fade2_drawmode : Media item edges of controls blend mode -- blendmode 00000000 item_grouphl : Media item edge when selected via grouping -- current RGB: 0,0,0 col_offlinetext : Media item "offline" text -- current RGB: 0,0,0 col_stretchmarker : Media item stretch marker line -- current RGB: 0,0,0 col_stretchmarker_h0 : Media item stretch marker handle (1x) -- current RGB: 0,0,0 col_stretchmarker_h1 : Media item stretch marker handle (>1x) -- current RGB: 0,0,0 col_stretchmarker_h2 : Media item stretch marker handle (<1x) -- current RGB: 0,0,0 col_stretchmarker_b : Media item stretch marker handle edge -- current RGB: 0,0,0 col_stretchmarkerm : Media item stretch marker blend mode -- blendmode 00000000 col_stretchmarker_text : Media item stretch marker text -- current RGB: 0,0,0 col_stretchmarker_tm : Media item transient guide handle -- current RGB: 0,0,0 take_marker : Media item take marker -- current RGB: 0,0,0 take_marker_sel : Media item take marker when item selected -- current RGB: 0,0,0 selitem_tag : Selected media item bar color -- current RGB: 0,0,0 activetake_tag : Active media item take bar color -- current RGB: 0,0,0 col_tr1_bg : Track background (odd tracks) -- current RGB: 0,0,0 col_tr2_bg : Track background (even tracks) -- current RGB: 0,0,0 selcol_tr1_bg : Selected track background (odd tracks) -- current RGB: 0,0,0 selcol_tr2_bg : Selected track background (even tracks) -- current RGB: 0,0,0 track_lane_tabcol : Track fixed lane button -- current RGB: 0,0,0 track_lanesolo_tabcol : Track fixed lane button when only this lane plays -- current RGB: 0,0,0 track_lanesolo_text : Track fixed lane button text -- current RGB: 0,0,0 track_lane_gutter : Track fixed lane add area -- current RGB: 0,0,0 track_lane_gutter_drawmode : Track fixed lane add fill mode -- blendmode 00000000 col_tr1_divline : Track divider line (odd tracks) -- current RGB: 0,0,0 col_tr2_divline : Track divider line (even tracks) -- current RGB: 0,0,0 col_envlane1_divline : Envelope lane divider line (odd tracks) -- current RGB: 0,0,0 col_envlane2_divline : Envelope lane divider line (even tracks) -- current RGB: 0,0,0 mute_overlay_col : Muted/unsoloed track/item overlay color -- current RGB: 0,0,0 mute_overlay_mode : Muted/unsoloed track/item overlay mode -- blendmode 00000000 inactive_take_overlay_col : Inactive take/lane overlay color -- current RGB: 0,0,0 inactive_take_overlay_mode : Inactive take/lane overlay mode -- blendmode 00000000 locked_overlay_col : Locked track/item overlay color -- current RGB: 0,0,0 locked_overlay_mode : Locked track/item overlay mode -- blendmode 00000000 marquee_fill : Marquee fill -- current RGB: 0,0,0 marquee_drawmode : Marquee fill mode -- blendmode 00000000 marquee_outline : Marquee outline -- current RGB: 0,0,0 marqueezoom_fill : Marquee zoom fill -- current RGB: 0,0,0 marqueezoom_drawmode : Marquee zoom fill mode -- blendmode 00000000 marqueezoom_outline : Marquee zoom outline -- current RGB: 0,0,0 areasel_fill : Razor edit area fill -- current RGB: 0,0,0 areasel_drawmode : Razor edit area fill mode -- blendmode 00000000 areasel_outline : Razor edit area outline -- current RGB: 0,0,0 areasel_outlinemode : Razor edit area outline mode -- blendmode 00000000 linkedlane_fill : Fixed lane comp area fill -- current RGB: 0,0,0 linkedlane_fillmode : Fixed lane comp area fill mode -- blendmode 00000000 linkedlane_outline : Fixed lane comp area outline -- current RGB: 0,0,0 linkedlane_outlinemode : Fixed lane comp area outline mode -- blendmode 00000000 linkedlane_unsynced : Fixed lane comp lane unsynced media item -- current RGB: 0,0,0 linkedlane_unsynced_mode : Fixed lane comp lane unsynced media item mode -- blendmode 00000000 col_cursor : Edit cursor -- current RGB: 0,0,0 col_cursor2 : Edit cursor (alternate) -- current RGB: 0,0,0 playcursor_color : Play cursor -- current RGB: 0,0,0 playcursor_drawmode : Play cursor mode -- blendmode 00000000 col_gridlines2 : Grid lines (start of measure) -- current RGB: 0,0,0 col_gridlines2dm : Grid lines (start of measure) - draw mode -- blendmode 00000000 col_gridlines3 : Grid lines (start of beats) -- current RGB: 0,0,0 col_gridlines3dm : Grid lines (start of beats) - draw mode -- blendmode 00000000 col_gridlines : Grid lines (in between beats) -- current RGB: 0,0,0 col_gridlines1dm : Grid lines (in between beats) - draw mode -- blendmode 00000000 guideline_color : Editing guide line -- current RGB: 0,0,0 guideline_drawmode : Editing guide mode -- blendmode 00000000 mouseitem_color : Mouse position indicator -- current RGB: 0,0,0 mouseitem_mode : Mouse position indicator mode -- blendmode 00000000 region : Regions -- current RGB: 0,0,0 region_lane_bg : Region lane background -- current RGB: 0,0,0 region_lane_text : Region text -- current RGB: 0,0,0 region_edge : Region edge -- current RGB: 0,0,0 region_edge_sel : Region text and edge (selected) -- current RGB: 0,0,0 marker : Markers -- current RGB: 0,0,0 marker_lane_bg : Marker lane background -- current RGB: 0,0,0 marker_lane_text : Marker text -- current RGB: 0,0,0 marker_edge : Marker edge -- current RGB: 0,0,0 marker_edge_sel : Marker text and edge (selected) -- current RGB: 0,0,0 col_tsigmark : Time signature change marker -- current RGB: 0,0,0 ts_lane_bg : Time signature lane background -- current RGB: 0,0,0 ts_lane_text : Time signature lane text -- current RGB: 0,0,0 timesig_sel_bg : Time signature marker selected background -- current RGB: 0,0,0 col_routinghl1 : Routing matrix row highlight -- current RGB: 0,0,0 col_routinghl2 : Routing matrix column highlight -- current RGB: 0,0,0 col_routingact : Routing matrix input activity highlight -- current RGB: 0,0,0 col_vudoint : Theme has interlaced VU meters -- bool 00000000 col_vuclip : VU meter clip indicator -- current RGB: 0,0,0 col_vudbscale : VU meters dB scales (not record armed) -- bool 00000000 col_vudbscale2 : VU meters dB scales (record armed) -- bool 00000000 col_vutop : VU meter top -- current RGB: 0,0,0 col_vumid : VU meter middle -- current RGB: 0,0,0 col_vubot : VU meter bottom -- current RGB: 0,0,0 col_vuintcol : VU meter interlace/edge color -- current RGB: 0,0,0 vu_gr_bgcol : VU meter gain reduction background -- current RGB: 0,0,0 vu_gr_fgcol : VU meter gain reduction indicator -- current RGB: 0,0,0 col_vumidi : VU meter midi activity -- current RGB: 0,0,0 col_vuind1 : VU (indicator) - no signal -- current RGB: 0,0,0 col_vuind2 : VU (indicator) - low signal -- current RGB: 0,0,0 col_vuind3 : VU (indicator) - med signal -- current RGB: 0,0,0 col_vuind4 : VU (indicator) - hot signal -- current RGB: 0,0,0 mcp_sends_normal : Sends text: normal -- current RGB: 0,0,0 mcp_sends_muted : Sends text: muted -- current RGB: 0,0,0 mcp_send_midihw : Sends text: MIDI hardware -- current RGB: 0,0,0 mcp_sends_levels : Sends level -- current RGB: 0,0,0 mcp_fx_normal : FX insert text: normal -- current RGB: 0,0,0 mcp_fx_bypassed : FX insert text: bypassed -- current RGB: 0,0,0 mcp_fx_offlined : FX insert text: offline -- current RGB: 0,0,0 mcp_fxparm_normal : FX parameter text: normal -- current RGB: 0,0,0 mcp_fxparm_bypassed : FX parameter text: bypassed -- current RGB: 0,0,0 mcp_fxparm_offlined : FX parameter text: offline -- current RGB: 0,0,0 tcp_list_scrollbar : List scrollbar (track panel) -- current RGB: 0,0,0 tcp_list_scrollbar_mode : List scrollbar (track panel) - draw mode -- blendmode 00000000 tcp_list_scrollbar_mouseover : List scrollbar mouseover (track panel) -- current RGB: 0,0,0 tcp_list_scrollbar_mouseover_mode : List scrollbar mouseover (track panel) - draw mode -- blendmode 00000000 mcp_list_scrollbar : List scrollbar (mixer panel) -- current RGB: 0,0,0 mcp_list_scrollbar_mode : List scrollbar (mixer panel) - draw mode -- blendmode 00000000 mcp_list_scrollbar_mouseover : List scrollbar mouseover (mixer panel) -- current RGB: 0,0,0 mcp_list_scrollbar_mouseover_mode : List scrollbar mouseover (mixer panel) - draw mode -- blendmode 00000000 midi_rulerbg : MIDI editor ruler background -- current RGB: 0,0,0 midi_rulerfg : MIDI editor ruler text -- current RGB: 0,0,0 midi_grid2 : MIDI editor grid line (start of measure) -- current RGB: 0,0,0 midi_griddm2 : MIDI editor grid line (start of measure) - draw mode -- blendmode 00000000 midi_grid3 : MIDI editor grid line (start of beats) -- current RGB: 0,0,0 midi_griddm3 : MIDI editor grid line (start of beats) - draw mode -- blendmode 00000000 midi_grid1 : MIDI editor grid line (between beats) -- current RGB: 0,0,0 midi_griddm1 : MIDI editor grid line (between beats) - draw mode -- blendmode 00000000 midi_trackbg1 : MIDI editor background color (naturals) -- current RGB: 0,0,0 midi_trackbg2 : MIDI editor background color (sharps/flats) -- current RGB: 0,0,0 midi_trackbg_outer1 : MIDI editor background color, out of bounds (naturals) -- current RGB: 0,0,0 midi_trackbg_outer2 : MIDI editor background color, out of bounds (sharps/flats) -- current RGB: 0,0,0 midi_selpitch1 : MIDI editor background color, selected pitch (naturals) -- current RGB: 0,0,0 midi_selpitch2 : MIDI editor background color, selected pitch (sharps/flats) -- current RGB: 0,0,0 midi_selbg : MIDI editor time selection color -- current RGB: 0,0,0 midi_selbg_drawmode : MIDI editor time selection fill mode -- blendmode 00000000 midi_gridhc : MIDI editor CC horizontal center line -- current RGB: 0,0,0 midi_gridhcdm : MIDI editor CC horizontal center line - draw mode -- blendmode 00000000 midi_gridh : MIDI editor CC horizontal line -- current RGB: 0,0,0 midi_gridhdm : MIDI editor CC horizontal line - draw mode -- blendmode 00000000 midi_ccbut : MIDI editor CC lane add/remove buttons -- current RGB: 0,0,0 midi_ccbut_text : MIDI editor CC lane button text -- current RGB: 0,0,0 midi_ccbut_arrow : MIDI editor CC lane button arrow -- current RGB: 0,0,0 midioct : MIDI editor octave line color -- current RGB: 0,0,0 midi_inline_trackbg1 : MIDI inline background color (naturals) -- current RGB: 0,0,0 midi_inline_trackbg2 : MIDI inline background color (sharps/flats) -- current RGB: 0,0,0 midioct_inline : MIDI inline octave line color -- current RGB: 0,0,0 midi_endpt : MIDI editor end marker -- current RGB: 0,0,0 midi_notebg : MIDI editor note, unselected (midi_note_colormap overrides) -- current RGB: 0,0,0 midi_notefg : MIDI editor note, selected (midi_note_colormap overrides) -- current RGB: 0,0,0 midi_notemute : MIDI editor note, muted, unselected (midi_note_colormap overrides) -- current RGB: 0,0,0 midi_notemute_sel : MIDI editor note, muted, selected (midi_note_colormap overrides) -- current RGB: 0,0,0 midi_itemctl : MIDI editor note controls -- current RGB: 0,0,0 midi_ofsn : MIDI editor note (offscreen) -- current RGB: 0,0,0 midi_ofsnsel : MIDI editor note (offscreen, selected) -- current RGB: 0,0,0 midi_editcurs : MIDI editor cursor -- current RGB: 0,0,0 midi_pkey1 : MIDI piano key color (naturals background, sharps/flats text) -- current RGB: 0,0,0 midi_pkey2 : MIDI piano key color (sharps/flats background, naturals text) -- current RGB: 0,0,0 midi_pkey3 : MIDI piano key color (selected) -- current RGB: 0,0,0 midi_noteon_flash : MIDI piano key note-on flash -- current RGB: 0,0,0 midi_leftbg : MIDI piano pane background -- current RGB: 0,0,0 midifont_col_light_unsel : MIDI editor note text and control color, unselected (light) -- current RGB: 0,0,0 midifont_col_dark_unsel : MIDI editor note text and control color, unselected (dark) -- current RGB: 0,0,0 midifont_mode_unsel : MIDI editor note text and control mode, unselected -- blendmode 00000000 midifont_col_light : MIDI editor note text and control color (light) -- current RGB: 0,0,0 midifont_col_dark : MIDI editor note text and control color (dark) -- current RGB: 0,0,0 midifont_mode : MIDI editor note text and control mode -- blendmode 00000000 score_bg : MIDI notation editor background -- current RGB: 0,0,0 score_fg : MIDI notation editor staff/notation/text -- current RGB: 0,0,0 score_sel : MIDI notation editor selected staff/notation/text -- current RGB: 0,0,0 score_timesel : MIDI notation editor time selection -- current RGB: 0,0,0 score_loop : MIDI notation editor loop points, selected pitch -- current RGB: 0,0,0 midieditorlist_bg : MIDI list editor background -- current RGB: 0,0,0 midieditorlist_fg : MIDI list editor text -- current RGB: 0,0,0 midieditorlist_grid : MIDI list editor grid lines -- current RGB: 0,0,0 midieditorlist_selbg : MIDI list editor selected row -- current RGB: 0,0,0 midieditorlist_selfg : MIDI list editor selected text -- current RGB: 0,0,0 midieditorlist_seliabg : MIDI list editor selected row (inactive) -- current RGB: 0,0,0 midieditorlist_seliafg : MIDI list editor selected text (inactive) -- current RGB: 0,0,0 midieditorlist_bg2 : MIDI list editor background (secondary) -- current RGB: 0,0,0 midieditorlist_fg2 : MIDI list editor text (secondary) -- current RGB: 0,0,0 midieditorlist_selbg2 : MIDI list editor selected row (secondary) -- current RGB: 0,0,0 midieditorlist_selfg2 : MIDI list editor selected text (secondary) -- current RGB: 0,0,0 col_explorer_sel : Media explorer selection -- current RGB: 0,0,0 col_explorer_seldm : Media explorer selection mode -- blendmode 00000000 col_explorer_seledge : Media explorer selection edge -- current RGB: 0,0,0 explorer_grid : Media explorer grid, markers -- current RGB: 0,0,0 explorer_pitchtext : Media explorer pitch detection text -- current RGB: 0,0,0 docker_shadow : Tab control shadow -- current RGB: 0,0,0 docker_selface : Tab control selected tab -- current RGB: 0,0,0 docker_unselface : Tab control unselected tab -- current RGB: 0,0,0 docker_text : Tab control text -- current RGB: 0,0,0 docker_text_sel : Tab control text selected tab -- current RGB: 0,0,0 docker_bg : Tab control background -- current RGB: 0,0,0 windowtab_bg : Tab control background in windows -- current RGB: 0,0,0 auto_item_unsel : Envelope: Unselected automation item -- current RGB: 0,0,0 col_env1 : Envelope: Volume (pre-FX) -- current RGB: 0,0,0 col_env2 : Envelope: Volume -- current RGB: 0,0,0 env_trim_vol : Envelope: Trim Volume -- current RGB: 0,0,0 col_env3 : Envelope: Pan (pre-FX) -- current RGB: 0,0,0 col_env4 : Envelope: Pan -- current RGB: 0,0,0 env_track_mute : Envelope: Mute -- current RGB: 0,0,0 col_env5 : Envelope: Master playrate -- current RGB: 0,0,0 col_env6 : Envelope: Master tempo -- current RGB: 0,0,0 col_env7 : Envelope: Width / Send volume -- current RGB: 0,0,0 col_env8 : Envelope: Send pan -- current RGB: 0,0,0 col_env9 : Envelope: Send volume 2 -- current RGB: 0,0,0 col_env10 : Envelope: Send pan 2 -- current RGB: 0,0,0 env_sends_mute : Envelope: Send mute -- current RGB: 0,0,0 col_env11 : Envelope: Audio hardware output volume -- current RGB: 0,0,0 col_env12 : Envelope: Audio hardware output pan -- current RGB: 0,0,0 col_env13 : Envelope: FX parameter 1 -- current RGB: 0,0,0 col_env14 : Envelope: FX parameter 2 -- current RGB: 0,0,0 col_env15 : Envelope: FX parameter 3 -- current RGB: 0,0,0 col_env16 : Envelope: FX parameter 4 -- current RGB: 0,0,0 env_item_vol : Envelope: Item take volume -- current RGB: 0,0,0 env_item_pan : Envelope: Item take pan -- current RGB: 0,0,0 env_item_mute : Envelope: Item take mute -- current RGB: 0,0,0 env_item_pitch : Envelope: Item take pitch -- current RGB: 0,0,0 wiring_grid2 : Wiring: Background -- current RGB: 0,0,0 wiring_grid : Wiring: Background grid lines -- current RGB: 0,0,0 wiring_border : Wiring: Box border -- current RGB: 0,0,0 wiring_tbg : Wiring: Box background -- current RGB: 0,0,0 wiring_ticon : Wiring: Box foreground -- current RGB: 0,0,0 wiring_recbg : Wiring: Record section background -- current RGB: 0,0,0 wiring_recitem : Wiring: Record section foreground -- current RGB: 0,0,0 wiring_media : Wiring: Media -- current RGB: 0,0,0 wiring_recv : Wiring: Receives -- current RGB: 0,0,0 wiring_send : Wiring: Sends -- current RGB: 0,0,0 wiring_fader : Wiring: Fader -- current RGB: 0,0,0 wiring_parent : Wiring: Master/Parent -- current RGB: 0,0,0 wiring_parentwire_border : Wiring: Master/Parent wire border -- current RGB: 0,0,0 wiring_parentwire_master : Wiring: Master/Parent to master wire -- current RGB: 0,0,0 wiring_parentwire_folder : Wiring: Master/Parent to parent folder wire -- current RGB: 0,0,0 wiring_pin_normal : Wiring: Pins normal -- current RGB: 0,0,0 wiring_pin_connected : Wiring: Pins connected -- current RGB: 0,0,0 wiring_pin_disconnected : Wiring: Pins disconnected -- current RGB: 0,0,0 wiring_horz_col : Wiring: Horizontal pin connections -- current RGB: 0,0,0 wiring_sendwire : Wiring: Send hanging wire -- current RGB: 0,0,0 wiring_hwoutwire : Wiring: Hardware output wire -- current RGB: 0,0,0 wiring_recinputwire : Wiring: Record input wire -- current RGB: 0,0,0 wiring_hwout : Wiring: System hardware outputs -- current RGB: 0,0,0 wiring_recinput : Wiring: System record inputs -- current RGB: 0,0,0 wiring_activity : Wiring: Activity lights -- current RGB: 0,0,0 autogroup : Automatic track group -- current RGB: 0,0,0 group_0 : Group #1 -- current RGB: 0,0,0 group_1 : Group #2 -- current RGB: 0,0,0 group_2 : Group #3 -- current RGB: 0,0,0 group_3 : Group #4 -- current RGB: 0,0,0 group_4 : Group #5 -- current RGB: 0,0,0 group_5 : Group #6 -- current RGB: 0,0,0 group_6 : Group #7 -- current RGB: 0,0,0 group_7 : Group #8 -- current RGB: 0,0,0 group_8 : Group #9 -- current RGB: 0,0,0 group_9 : Group #10 -- current RGB: 0,0,0 group_10 : Group #11 -- current RGB: 0,0,0 group_11 : Group #12 -- current RGB: 0,0,0 group_12 : Group #13 -- current RGB: 0,0,0 group_13 : Group #14 -- current RGB: 0,0,0 group_14 : Group #15 -- current RGB: 0,0,0 group_15 : Group #16 -- current RGB: 0,0,0 group_16 : Group #17 -- current RGB: 0,0,0 group_17 : Group #18 -- current RGB: 0,0,0 group_18 : Group #19 -- current RGB: 0,0,0 group_19 : Group #20 -- current RGB: 0,0,0 group_20 : Group #21 -- current RGB: 0,0,0 group_21 : Group #22 -- current RGB: 0,0,0 group_22 : Group #23 -- current RGB: 0,0,0 group_23 : Group #24 -- current RGB: 0,0,0 group_24 : Group #25 -- current RGB: 0,0,0 group_25 : Group #26 -- current RGB: 0,0,0 group_26 : Group #27 -- current RGB: 0,0,0 group_27 : Group #28 -- current RGB: 0,0,0 group_28 : Group #29 -- current RGB: 0,0,0 group_29 : Group #30 -- current RGB: 0,0,0 group_30 : Group #31 -- current RGB: 0,0,0 group_31 : Group #32 -- current RGB: 0,0,0 group_32 : Group #33 -- current RGB: 0,0,0 group_33 : Group #34 -- current RGB: 0,0,0 group_34 : Group #35 -- current RGB: 0,0,0 group_35 : Group #36 -- current RGB: 0,0,0 group_36 : Group #37 -- current RGB: 0,0,0 group_37 : Group #38 -- current RGB: 0,0,0 group_38 : Group #39 -- current RGB: 0,0,0 group_39 : Group #40 -- current RGB: 0,0,0 group_40 : Group #41 -- current RGB: 0,0,0 group_41 : Group #42 -- current RGB: 0,0,0 group_42 : Group #43 -- current RGB: 0,0,0 group_43 : Group #44 -- current RGB: 0,0,0 group_44 : Group #45 -- current RGB: 0,0,0 group_45 : Group #46 -- current RGB: 0,0,0 group_46 : Group #47 -- current RGB: 0,0,0 group_47 : Group #48 -- current RGB: 0,0,0 group_48 : Group #49 -- current RGB: 0,0,0 group_49 : Group #50 -- current RGB: 0,0,0 group_50 : Group #51 -- current RGB: 0,0,0 group_51 : Group #52 -- current RGB: 0,0,0 group_52 : Group #53 -- current RGB: 0,0,0 group_53 : Group #54 -- current RGB: 0,0,0 group_54 : Group #55 -- current RGB: 0,0,0 group_55 : Group #56 -- current RGB: 0,0,0 group_56 : Group #57 -- current RGB: 0,0,0 group_57 : Group #58 -- current RGB: 0,0,0 group_58 : Group #59 -- current RGB: 0,0,0 group_59 : Group #60 -- current RGB: 0,0,0 group_60 : Group #61 -- current RGB: 0,0,0 group_61 : Group #62 -- current RGB: 0,0,0 group_62 : Group #63 -- current RGB: 0,0,0 group_63 : Group #64 -- current RGB: 0,0,0
function reaper.SetThemeColor(ini_key, color, flags) end

---@param section_id integer
---@param command_id integer
---@param state integer
---@return boolean
--- Updates the toggle state of an action, returns true if succeeded. Only ReaScripts can have their toggle states changed programmatically. See RefreshToolbar2.
function reaper.SetToggleCommandState(section_id, command_id, state) end

---@param tr MediaTrack
---@param mode integer
function reaper.SetTrackAutomationMode(tr, mode) end

---@param track MediaTrack
---@param color integer
--- Set the custom track color, color is OS dependent (i.e. ColorToNative(r,g,b). To unset the track color, see SetMediaTrackInfo_Value I_CUSTOMCOLOR
function reaper.SetTrackColor(track, color) end

---@param track MediaTrack
---@param flag integer
---@param str string
---@return boolean
--- Set all MIDI lyrics on the track. Lyrics will be stuffed into any MIDI items found in range. Flag is unused at present. str is passed in as beat position, tab, text, tab (example with flag=2: "1.1.2\tLyric for measure 1 beat 2\t2.1.1\tLyric for measure 2 beat 1 "). See GetTrackMIDILyrics
function reaper.SetTrackMIDILyrics(track, flag, str) end

---@param track integer
---@param pitch integer
---@param chan integer
---@param name string
---@return boolean
--- channel < 0 assigns these note names to all channels.
function reaper.SetTrackMIDINoteName(track, pitch, chan, name) end

---@param proj ReaProject
---@param track MediaTrack
---@param pitch integer
---@param chan integer
---@param name string
---@return boolean
--- channel < 0 assigns note name to all channels. pitch 128 assigns name for CC0, pitch 129 for CC1, etc.
function reaper.SetTrackMIDINoteNameEx(proj, track, pitch, chan, name) end

---@param track MediaTrack
---@param selected boolean
function reaper.SetTrackSelected(track, selected) end

---@param tr MediaTrack
---@param category integer
---@param sendidx integer
---@param parmname string
---@param newvalue number
---@return boolean
--- Set send/receive/hardware output numerical-value attributes, return true on success. category is 0 for hardware outputs parameter names: B_MUTE : bool * B_PHASE : bool * : true to flip phase B_MONO : bool * D_VOL : double * : 1.0 = +0dB etc D_PAN : double * : -1..+1 D_PANLAW : double * : 1.0=+0.0db, 0.5=-6dB, -1.0 = projdef etc I_SENDMODE : int * : 0=post-fader, 1=pre-fx, 2=post-fx (deprecated), 3=post-fx I_AUTOMODE : int * : automation mode (-1=use track automode, 0=trim/off, 1=read, 2=touch, 3=write, 4=latch) I_SRCCHAN : int * : -1 for no audio send. Low 10 bits specify channel offset, and higher bits specify channel count. (srcchan>>10) == 0 for stereo, 1 for mono, 2 for 4 channel, 3 for 6 channel, etc. I_DSTCHAN : int * : low 10 bits are destination index, &1024 set to mix to mono. I_MIDIFLAGS : int * : low 5 bits=source channel 0=all, 1-16, 31=MIDI send disabled, next 5 bits=dest channel, 0=orig, 1-16=chan. &1024 for faders-send MIDI vol/pan. (>>14)&255 = src bus (0 for all, 1 for normal, 2+). (>>22)&255=destination bus (0 for all, 1 for normal, 2+) See CreateTrackSend , RemoveTrackSend , GetTrackNumSends.
function reaper.SetTrackSendInfo_Value(tr, category, sendidx, parmname, newvalue) end

---@param track MediaTrack
---@param send_idx integer
---@param pan number
---@param isend integer
---@return boolean
--- send_idx=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1 for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
function reaper.SetTrackSendUIPan(track, send_idx, pan, isend) end

---@param track MediaTrack
---@param send_idx integer
---@param vol number
---@param isend integer
---@return boolean
--- send_idx=0 for hw ouputs, >=nb_of_hw_ouputs for sends. isend=1 for end of edit, -1 for an instant edit (such as reset), 0 for normal tweak.
function reaper.SetTrackSendUIVol(track, send_idx, vol, isend) end

---@param track MediaTrack
---@param str string
---@param isundo boolean
---@return boolean
--- Sets the RPPXML state of a track, returns true if successful. Undo flag is a performance/caching hint.
function reaper.SetTrackStateChunk(track, str, isundo) end

---@param track MediaTrack
---@param monitor integer
---@param igngroupflags integer
---@return integer
--- monitor: 0=no monitoring, 1=monitoring, 2=auto-monitoring. returns new value or -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
function reaper.SetTrackUIInputMonitor(track, monitor, igngroupflags) end

---@param track MediaTrack
---@param mute integer
---@param igngroupflags integer
---@return integer
--- mute: 0 sets mute, 0=unsets mute. returns new value or -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
function reaper.SetTrackUIMute(track, mute, igngroupflags) end

---@param track MediaTrack
---@param pan number
---@param relative boolean
---@param done boolean
---@param igngroupflags integer
---@return number
--- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
function reaper.SetTrackUIPan(track, pan, relative, done, igngroupflags) end

---@param track MediaTrack
---@param polarity integer
---@param igngroupflags integer
---@return integer
--- polarity (AKA phase): 0=inverted. returns new value or -1 if error.igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
function reaper.SetTrackUIPolarity(track, polarity, igngroupflags) end

---@param track MediaTrack
---@param recarm integer
---@param igngroupflags integer
---@return integer
--- recarm: 0 sets recarm, 0=unsets recarm. returns new value or -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
function reaper.SetTrackUIRecArm(track, recarm, igngroupflags) end

---@param track MediaTrack
---@param solo integer
---@param igngroupflags integer
---@return integer
--- solo: <0 toggles, 1 sets solo (default mode), 0=unsets solo, 2 sets solo (non-SIP), 4 sets solo (SIP). returns new value or -1 if error. igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
function reaper.SetTrackUISolo(track, solo, igngroupflags) end

---@param track MediaTrack
---@param volume number
---@param relative boolean
---@param done boolean
---@param igngroupflags integer
---@return number
--- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
function reaper.SetTrackUIVolume(track, volume, relative, done, igngroupflags) end

---@param track MediaTrack
---@param width number
---@param relative boolean
---@param done boolean
---@param igngroupflags integer
---@return number
--- igngroupflags: &1 to prevent track grouping, &2 to prevent selection ganging
function reaper.SetTrackUIWidth(track, width, relative, done, igngroupflags) end

---@param section KbdSectionInfo
---@param callerWnd HWND
function reaper.ShowActionList(section, callerWnd) end

---@param msg string
--- Show a message to the user (also useful for debugging). Send "\n" for newline, "" to clear the console. Prefix string with "!SHOW:" and text will be added to console without opening the window. See ClearConsole
function reaper.ShowConsoleMsg(msg) end

---@param msg string
---@param title string
---@param type integer
---@return integer
--- type 0=OK,1=OKCANCEL,2=ABORTRETRYIGNORE,3=YESNOCANCEL,4=YESNO,5=RETRYCANCEL : ret 1=OK,2=CANCEL,3=ABORT,4=RETRY,5=IGNORE,6=YES,7=NO
function reaper.ShowMessageBox(msg, title, type) end

---@param name string
---@param x integer
---@param y integer
---@param hwndParent HWND
---@param ctx identifier
---@param ctx2 integer
---@param ctx3 integer
--- shows a context menu, valid names include: track_input, track_panel, track_area, track_routing, item, ruler, envelope, envelope_point, envelope_item. ctxOptional can be a track pointer for track_*, item pointer for item* (but is optional). for envelope_point, ctx2Optional has point index, ctx3Optional has item index (0=main envelope, 1=first AI). for envelope_item, ctx2Optional has AI index (1=first AI)
function reaper.ShowPopupMenu(name, x, y, hwndParent, ctx, ctx2, ctx3) end

---@param y number
---@return number
function reaper.SLIDER2DB(y) end

---@param project ReaProject
---@param time_pos number
---@return number
function reaper.SnapToGrid(project, time_pos) end

---@param solo integer
--- solo=2 for SIP
function reaper.SoloAllTracks(solo) end

---@return HWND
--- gets the splash window, in case you want to display a message over it. Returns NULL when the splash window is not displayed.
function reaper.Splash_GetWnd() end

---@param item MediaItem
---@param position number
---@return MediaItem
--- the original item becomes the left-hand split, the function returns the right-hand split (or NULL if the split failed)
function reaper.SplitMediaItem(item, position) end

---@param str string
---@param gGUID string
---@return string gGUID
function reaper.stringToGuid(str, gGUID) end

---@param mode integer
---@param msg1 integer
---@param msg2 integer
---@param msg3 integer
--- Stuffs a 3 byte MIDI message into either the Virtual MIDI Keyboard queue, or the MIDI-as-control input queue, or sends to a MIDI hardware output. mode=0 for VKB, 1 for control (actions map etc), 2 for VKB-on-current-channel; 16 for external MIDI device 0, 17 for external MIDI device 1, etc; see GetNumMIDIOutputs , GetMIDIOutputName.
function reaper.StuffMIDIMessage(mode, msg1, msg2, msg3) end

---@param take MediaItem_Take
---@param fxname string
---@param instantiate integer
---@return integer
--- Adds or queries the position of a named FX in a take. See TrackFX_AddByName () for information on fxname and instantiate. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_AddByName(take, fxname, instantiate) end

---@param src_take MediaItem_Take
---@param src_fx integer
---@param dest_take MediaItem_Take
---@param dest_fx integer
---@param is_move boolean
--- Copies (or moves) FX from src_take to dest_take. Can be used with src_take=dest_take to reorder. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_CopyToTake(src_take, src_fx, dest_take, dest_fx, is_move) end

---@param src_take MediaItem_Take
---@param src_fx integer
---@param dest_track MediaTrack
---@param dest_fx integer
---@param is_move boolean
--- Copies (or moves) FX from src_take to dest_track. dest_fx can have 0x1000000 set to reference input FX. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_CopyToTrack(src_take, src_fx, dest_track, dest_fx, is_move) end

---@param take MediaItem_Take
---@param fx integer
---@return boolean
--- Remove a FX from take chain (returns true on success) FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_Delete(take, fx) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_EndParamEdit(take, fx, param) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@param val number
---@return boolean retval, string buf
--- Note: only works with FX that support Cockos VST extensions. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_FormatParamValue(take, fx, param, val) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@param value number
---@param buf string
---@return boolean retval, string buf
--- Note: only works with FX that support Cockos VST extensions. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_FormatParamValueNormalized(take, fx, param, value, buf) end

---@param take MediaItem_Take
---@return integer
--- returns index of effect visible in chain, or -1 for chain hidden, or -2 for chain visible but no effect selected
function reaper.TakeFX_GetChainVisible(take) end

---@param take MediaItem_Take
---@return integer
function reaper.TakeFX_GetCount(take) end

---@param take MediaItem_Take
---@param fx integer
---@return boolean
--- See TakeFX_SetEnabled FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetEnabled(take, fx) end

---@param take MediaItem_Take
---@param fxindex integer
---@param parameterindex integer
---@param create boolean
---@return TrackEnvelope
--- Returns the FX parameter envelope. If the envelope does not exist and create=true, the envelope will be created. If the envelope already exists and is bypassed and create=true, then the envelope will be unbypassed. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetEnvelope(take, fxindex, parameterindex, create) end

---@param take MediaItem_Take
---@param index integer
---@return HWND
--- returns HWND of floating window for effect index, if any FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetFloatingWindow(take, index) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean retval, string buf
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetFormattedParamValue(take, fx, param) end

---@param take MediaItem_Take
---@param fx integer
---@return string GUID
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetFXGUID(take, fx) end

---@param take MediaItem_Take
---@param fx integer
---@return boolean retval, string buf
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetFXName(take, fx) end

---@param take MediaItem_Take
---@param fx integer
---@return integer retval, integer inputPins, integer outputPins
--- Gets the number of input/output pins for FX if available, returns plug-in type or -1 on error FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetIOSize(take, fx) end

---@param take MediaItem_Take
---@param fx integer
---@param parmname string
---@return boolean retval, string buf
--- gets plug-in specific named configuration value (returns true on success). see TrackFX_GetNamedConfigParm FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetNamedConfigParm(take, fx, parmname) end

---@param take MediaItem_Take
---@param fx integer
---@return integer
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetNumParams(take, fx) end

---@param take MediaItem_Take
---@param fx integer
---@return boolean
--- See TakeFX_SetOffline FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetOffline(take, fx) end

---@param take MediaItem_Take
---@param fx integer
---@return boolean
--- Returns true if this FX UI is open in the FX chain window or a floating window. See TakeFX_SetOpen FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetOpen(take, fx) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return number retval, number minval, number maxval
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetParam(take, fx, param) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean retval, number step, number smallstep, number largestep, boolean istoggle
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetParameterStepSizes(take, fx, param) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return number retval, number minval, number maxval, number midval
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetParamEx(take, fx, param) end

---@param take MediaItem_Take
---@param fx integer
---@param ident_str string
---@return integer
--- gets the parameter index from an identifying string (:wet, :bypass, or a string returned from GetParamIdent), or -1 if unknown. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetParamFromIdent(take, fx, ident_str) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean retval, string buf
--- gets an identifying string for the parameter FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetParamIdent(take, fx, param) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return boolean retval, string buf
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetParamName(take, fx, param) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@return number
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetParamNormalized(take, fx, param) end

---@param take MediaItem_Take
---@param fx integer
---@param isoutput integer
---@param pin integer
---@return integer retval, integer high32
--- gets the effective channel mapping bitmask for a particular pin. high32Out will be set to the high 32 bits. Add 0x1000000 to pin index in order to access the second 64 bits of mappings independent of the first 64 bits. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetPinMappings(take, fx, isoutput, pin) end

---@param take MediaItem_Take
---@param fx integer
---@return boolean retval, string presetname
--- Get the name of the preset currently showing in the REAPER dropdown, or the full path to a factory preset file for VST3 plug-ins (.vstpreset). See TakeFX_SetPreset . FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetPreset(take, fx) end

---@param take MediaItem_Take
---@param fx integer
---@return integer retval, integer numberOfPresets
--- Returns current preset index, or -1 if error. numberOfPresetsOut will be set to total number of presets available. See TakeFX_SetPresetByIndex FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetPresetIndex(take, fx) end

---@param take MediaItem_Take
---@param fx integer
---@return string fn
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_GetUserPresetFilename(take, fx) end

---@param take MediaItem_Take
---@param fx integer
---@param presetmove integer
---@return boolean
--- presetmove==1 activates the next preset, presetmove==-1 activates the previous preset, etc. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_NavigatePresets(take, fx, presetmove) end

---@param take MediaItem_Take
---@param fx integer
---@param enabled boolean
--- See TakeFX_GetEnabled FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_SetEnabled(take, fx, enabled) end

---@param take MediaItem_Take
---@param fx integer
---@param parmname string
---@param value string
---@return boolean
--- gets plug-in specific named configuration value (returns true on success). see TrackFX_SetNamedConfigParm FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_SetNamedConfigParm(take, fx, parmname, value) end

---@param take MediaItem_Take
---@param fx integer
---@param offline boolean
--- See TakeFX_GetOffline FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_SetOffline(take, fx, offline) end

---@param take MediaItem_Take
---@param fx integer
---@param open boolean
--- Open this FX UI. See TakeFX_GetOpen FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_SetOpen(take, fx, open) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@param val number
---@return boolean
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_SetParam(take, fx, param, val) end

---@param take MediaItem_Take
---@param fx integer
---@param param integer
---@param value number
---@return boolean
--- FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_SetParamNormalized(take, fx, param, value) end

---@param take MediaItem_Take
---@param fx integer
---@param isoutput integer
---@param pin integer
---@param low32bits integer
---@param hi32bits integer
---@return boolean
--- sets the channel mapping bitmask for a particular pin. returns false if unsupported (not all types of plug-ins support this capability). Add 0x1000000 to pin index in order to access the second 64 bits of mappings independent of the first 64 bits. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_SetPinMappings(take, fx, isoutput, pin, low32bits, hi32bits) end

---@param take MediaItem_Take
---@param fx integer
---@param presetname string
---@return boolean
--- Activate a preset with the name shown in the REAPER dropdown. Full paths to .vstpreset files are also supported for VST3 plug-ins. See TakeFX_GetPreset . FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_SetPreset(take, fx, presetname) end

---@param take MediaItem_Take
---@param fx integer
---@param idx integer
---@return boolean
--- Sets the preset idx, or the factory preset (idx==-2), or the default user preset (idx==-1). Returns true on success. See TakeFX_GetPresetIndex . FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_SetPresetByIndex(take, fx, idx) end

---@param take MediaItem_Take
---@param index integer
---@param showFlag integer
--- showflag=0 for hidechain, =1 for show chain(index valid), =2 for hide floating window(index valid), =3 for show floating window (index valid) FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TakeFX_Show(take, index, showFlag) end

---@param take MediaItem_Take
---@return boolean
--- Returns true if the active take contains MIDI.
function reaper.TakeIsMIDI(take) end

---@param section string
---@param idx integer
---@return boolean retval, string name
--- Gets theme layout information. section can be 'global' for global layout override, 'seclist' to enumerate a list of layout sections, otherwise a layout section such as 'mcp', 'tcp', 'trans', etc. idx can be -1 to query the current value, -2 to get the description of the section (if not global), -3 will return the current context DPI-scaling (256=normal, 512=retina, etc), or 0..x. returns false if failed.
function reaper.ThemeLayout_GetLayout(section, idx) end

---@param wp integer
---@return string retval, string desc, integer value, integer defValue, integer minValue, integer maxValue
--- returns theme layout parameter. return value is cfg-name, or nil/empty if out of range.
function reaper.ThemeLayout_GetParameter(wp) end

--- Refreshes all layouts
function reaper.ThemeLayout_RefreshAll() end

---@param section string
---@param layout string
---@return boolean
--- Sets theme layout override for a particular section -- section can be 'global' or 'mcp' etc. If setting global layout, prefix a ! to the layout string to clear any per-layout overrides. Returns false if failed.
function reaper.ThemeLayout_SetLayout(section, layout) end

---@param wp integer
---@param value integer
---@param persist boolean
---@return boolean
--- sets theme layout parameter to value. persist=true in order to have change loaded on next theme load. note that the caller should update layouts via ??? to make changes visible.
function reaper.ThemeLayout_SetParameter(wp, value, persist) end

---@return number
--- Gets a precise system timestamp in seconds
function reaper.time_precise() end

---@param proj ReaProject
---@param tpos number
---@param measuresIn optional integer
---@return number
--- convert a beat position (or optionally a beats+measures if measures is non-NULL) to time.
function reaper.TimeMap2_beatsToTime(proj, tpos, measuresIn) end

---@param proj ReaProject
---@param time number
---@return number
--- get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
function reaper.TimeMap2_GetDividedBpmAtTime(proj, time) end

---@param proj ReaProject
---@param time number
---@return number
--- when does the next time map (tempo or time sig) change occur
function reaper.TimeMap2_GetNextChangeTime(proj, time) end

---@param proj ReaProject
---@param qn number
---@return number
--- converts project QN position to time.
function reaper.TimeMap2_QNToTime(proj, qn) end

---@param proj ReaProject
---@param tpos number
---@return number retval, integer measures, integer cml, number fullbeats, integer cdenom
--- convert a time into beats. if measures is non-NULL, measures will be set to the measure count, return value will be beats since measure. if cml is non-NULL, will be set to current measure length in beats (i.e. time signature numerator) if fullbeats is non-NULL, and measures is non-NULL, fullbeats will get the full beat count (same value returned if measures is NULL). if cdenom is non-NULL, will be set to the current time signature denominator.
function reaper.TimeMap2_timeToBeats(proj, tpos) end

---@param proj ReaProject
---@param tpos number
---@return number
--- converts project time position to QN position.
function reaper.TimeMap2_timeToQN(proj, tpos) end

---@param proj ReaProject
---@return number retval, boolean dropFrame
--- Gets project framerate, and optionally whether it is drop-frame timecode
function reaper.TimeMap_curFrameRate(proj) end

---@param time number
---@return number
--- get the effective BPM at the time (seconds) position (i.e. 2x in /8 signatures)
function reaper.TimeMap_GetDividedBpmAtTime(time) end

---@param proj ReaProject
---@param measure integer
---@return number retval, number qn_start, number qn_end, integer timesig_num, integer timesig_denom, number tempo
--- Get the QN position and time signature information for the start of a measure. Return the time in seconds of the measure start.
function reaper.TimeMap_GetMeasureInfo(proj, measure) end

---@param proj ReaProject
---@param time number
---@param pattern string
---@return integer retval, string pattern
--- Fills in a string representing the active metronome pattern. For example, in a 7/8 measure divided 3+4, the pattern might be "ABCABCD". For backwards compatibility, by default the function will return 1 for each primary beat and 2 for each non-primary beat, so "1221222" in this example, and does not support triplets. If buf is set to "EXTENDED", the function will return the full string as displayed in the pattern editor, including all beat types and triplet representations. Pass in "SET:string" with a correctly formed pattern string matching the current time signature numerator to set the click pattern. The time signature numerator can be deduced from the returned string, and the function returns the time signature denominator.
function reaper.TimeMap_GetMetronomePattern(proj, time, pattern) end

---@param proj ReaProject
---@param time number
---@return integer timesig_num, integer timesig_denom, number tempo
--- get the effective time signature and tempo
function reaper.TimeMap_GetTimeSigAtTime(proj, time) end

---@param proj ReaProject
---@param qn number
---@return integer retval, number qnMeasureStart, number qnMeasureEnd
--- Find which measure the given QN position falls in.
function reaper.TimeMap_QNToMeasures(proj, qn) end

---@param qn number
---@return number
--- converts project QN position to time.
function reaper.TimeMap_QNToTime(qn) end

---@param proj ReaProject
---@param qn number
---@return number
--- Converts project quarter note count (QN) to time. QN is counted from the start of the project, regardless of any partial measures. See TimeMap2_QNToTime
function reaper.TimeMap_QNToTime_abs(proj, qn) end

---@param tpos number
---@return number
--- converts project QN position to time.
function reaper.TimeMap_timeToQN(tpos) end

---@param proj ReaProject
---@param tpos number
---@return number
--- Converts project time position to quarter note count (QN). QN is counted from the start of the project, regardless of any partial measures. See TimeMap2_timeToQN
function reaper.TimeMap_timeToQN_abs(proj, tpos) end

---@param track MediaTrack
---@param send_idx integer
---@return boolean
--- send_idx=0 for hw ouputs, >=nb_of_hw_ouputs for sends.
function reaper.ToggleTrackSendUIMute(track, send_idx) end

---@param track MediaTrack
---@param channel integer
---@param clear boolean
---@return number
--- Returns meter hold state, in dB*0.01 (0 = +0dB, -0.01 = -1dB, 0.02 = +2dB, etc). If clear is set, clears the meter hold. If channel==1024 or channel==1025, returns loudness values if this is the master track or this track's VU meters are set to display loudness.
function reaper.Track_GetPeakHoldDB(track, channel, clear) end

---@param track MediaTrack
---@param channel integer
---@return number
--- Returns peak meter value (1.0=+0dB, 0.0=-inf) for channel. If channel==1024 or channel==1025, returns loudness values if this is the master track or this track's VU meters are set to display loudness.
function reaper.Track_GetPeakInfo(track, channel) end

---@param fmt string
---@param xpos integer
---@param ypos integer
---@param topmost boolean
--- displays tooltip at location, or removes if empty string
function reaper.TrackCtl_SetToolTip(fmt, xpos, ypos, topmost) end

---@param track MediaTrack
---@param fxname string
---@param recFX boolean
---@param instantiate integer
---@return integer
--- Adds or queries the position of a named FX from the track FX chain (recFX=false) or record input FX/monitoring FX (recFX=true, monitoring FX are on master track). Specify a negative value for instantiate to always create a new effect, 0 to only query the first instance of an effect, or a positive value to add an instance if one is not found. If instantiate is <= -1000, it is used for the insertion position (-1000 is first item in chain, -1001 is second, etc). fxname can have prefix to specify type: VST3:,VST2:,VST:,AU:,JS:, or DX:, or FXADD: which adds selected items from the currently-open FX browser, FXADD:2 to limit to 2 FX added, or FXADD:2e to only succeed if exactly 2 FX are selected. Returns -1 on failure or the new position in chain on success. FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_AddByName(track, fxname, recFX, instantiate) end

---@param src_track MediaTrack
---@param src_fx integer
---@param dest_take MediaItem_Take
---@param dest_fx integer
---@param is_move boolean
--- Copies (or moves) FX from src_track to dest_take. src_fx can have 0x1000000 set to reference input FX. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_CopyToTake(src_track, src_fx, dest_take, dest_fx, is_move) end

---@param src_track MediaTrack
---@param src_fx integer
---@param dest_track MediaTrack
---@param dest_fx integer
---@param is_move boolean
--- Copies (or moves) FX from src_track to dest_track. Can be used with src_track=dest_track to reorder, FX indices have 0x1000000 set to reference input FX. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_CopyToTrack(src_track, src_fx, dest_track, dest_fx, is_move) end

---@param track MediaTrack
---@param fx integer
---@return boolean
--- Remove a FX from track chain (returns true on success) FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_Delete(track, fx) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_EndParamEdit(track, fx, param) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@param val number
---@return boolean retval, string buf
--- Note: only works with FX that support Cockos VST extensions. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_FormatParamValue(track, fx, param, val) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@param value number
---@param buf string
---@return boolean retval, string buf
--- Note: only works with FX that support Cockos VST extensions. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_FormatParamValueNormalized(track, fx, param, value, buf) end

---@param track MediaTrack
---@param fxname string
---@param instantiate boolean
---@return integer
--- Get the index of the first track FX insert that matches fxname. If the FX is not in the chain and instantiate is true, it will be inserted. See TrackFX_GetInstrument , TrackFX_GetEQ . Deprecated in favor of TrackFX_AddByName.
function reaper.TrackFX_GetByName(track, fxname, instantiate) end

---@param track MediaTrack
---@return integer
--- returns index of effect visible in chain, or -1 for chain hidden, or -2 for chain visible but no effect selected
function reaper.TrackFX_GetChainVisible(track) end

---@param track MediaTrack
---@return integer
function reaper.TrackFX_GetCount(track) end

---@param track MediaTrack
---@param fx integer
---@return boolean
--- See TrackFX_SetEnabled FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetEnabled(track, fx) end

---@param track MediaTrack
---@param instantiate boolean
---@return integer
--- Get the index of ReaEQ in the track FX chain. If ReaEQ is not in the chain and instantiate is true, it will be inserted. See TrackFX_GetInstrument , TrackFX_GetByName.
function reaper.TrackFX_GetEQ(track, instantiate) end

---@param track MediaTrack
---@param fxidx integer
---@param bandtype integer
---@param bandidx integer
---@return boolean
--- Returns true if the EQ band is enabled. Returns false if the band is disabled, or if track/fxidx is not ReaEQ. Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass. Bandidx (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc. See TrackFX_GetEQ , TrackFX_GetEQParam , TrackFX_SetEQParam , TrackFX_SetEQBandEnabled . FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetEQBandEnabled(track, fxidx, bandtype, bandidx) end

---@param track MediaTrack
---@param fxidx integer
---@param paramidx integer
---@return boolean retval, integer bandtype, integer bandidx, integer paramtype, number normval
--- Returns false if track/fxidx is not ReaEQ. Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass. Bandidx (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc. Paramtype (ignored for master gain): 0=freq, 1=gain, 2=Q. See TrackFX_GetEQ , TrackFX_SetEQParam , TrackFX_GetEQBandEnabled , TrackFX_SetEQBandEnabled . FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetEQParam(track, fxidx, paramidx) end

---@param track MediaTrack
---@param index integer
---@return HWND
--- returns HWND of floating window for effect index, if any FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetFloatingWindow(track, index) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean retval, string buf
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetFormattedParamValue(track, fx, param) end

---@param track MediaTrack
---@param fx integer
---@return string GUID
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetFXGUID(track, fx) end

---@param track MediaTrack
---@param fx integer
---@return boolean retval, string buf
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetFXName(track, fx) end

---@param track MediaTrack
---@return integer
--- Get the index of the first track FX insert that is a virtual instrument, or -1 if none. See TrackFX_GetEQ , TrackFX_GetByName.
function reaper.TrackFX_GetInstrument(track) end

---@param track MediaTrack
---@param fx integer
---@return integer retval, integer inputPins, integer outputPins
--- Gets the number of input/output pins for FX if available, returns plug-in type or -1 on error FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetIOSize(track, fx) end

---@param track MediaTrack
---@param fx integer
---@param parmname string
---@return boolean retval, string buf
--- gets plug-in specific named configuration value (returns true on success). Supported values for read: pdc : PDC latency in_pin_X : name of input pin X out_pin_X : name of output pin X fx_type : type string fx_ident : type-specific identifier fx_name : name of FX (also supported as original_name) GainReduction_dB : [ReaComp + other supported compressors] parent_container : FX ID of parent container, if any (v7.06+) container_count : [Container] number of FX in container container_item.X : FX ID of item in container (first item is container_item.0) (v7.06+) param.X.container_map.hint_id : unique ID of mapping (preserved if mapping order changes) param.X.container_map.delete : read this value in order to remove the mapping for this parameter container_map.add : read from this value to add a new container parameter mapping -- will return new parameter index (accessed via param.X.container_map.*) container_map.add.FXID.PARMIDX : read from this value to add/get container parameter mapping for FXID/PARMIDX -- will return the parameter index (accessed via param.X.container_map.*). FXID can be a full address (must be a child of the container) or a 0-based sub-index (v7.06+). container_map.get.FXID.PARMIDX : read from this value to get container parameter mapping for FXID/PARMIDX -- will return the parameter index (accessed via param.X.container_map.*). FXID can be a full address (must be a child of the container) or a 0-based sub-index (v7.06+). chain_pdc_actual : returns the actual chain latency in samples, only valid after playback has commenced, may be rounded up to block size. chain_pdc_reporting : returns the reported chain latency, always valid, not rounded to block size. Supported values for read/write: vst_chunk[_program] : base64-encoded VST-specific chunk. clap_chunk : base64-encoded CLAP-specific chunk. param.X.lfo.[active,dir,phase,speed,strength,temposync,free,shape] : parameter moduation LFO state param.X.acs.[active,dir,strength,attack,release,dblo,dbhi,chan,stereo,x2,y2] : parameter modulation ACS state param.X.plink.[active,scale,offset,effect,param,midi_bus,midi_chan,midi_msg,midi_msg2] : parameter link/MIDI link: set effect=-100 to support midi_* param.X.mod.[active,baseline,visible] : parameter module global settings param.X.learn.[midi1,midi2,osc] : first two bytes of MIDI message, or OSC string if set param.X.learn.mode : absolution/relative mode flag (0: Absolute, 1: 127=-1,1=+1, 2: 63=-1, 65=+1, 3: 65=-1, 1=+1, 4: toggle if nonzero) param.X.learn.flags : &1=selected track only, &2=soft takeover, &4=focused FX only, &8=LFO retrigger, &16=visible FX only param.X.container_map.fx_index : index of FX contained in container param.X.container_map.fx_parm : parameter index of parameter of FX contained in container param.X.container_map.aliased_name : name of parameter (if user-renamed, otherwise fails) BANDTYPEx, BANDENABLEDx : band configuration [ReaEQ] THRESHOLD, CEILING, TRUEPEAK : [ReaLimit] NUMCHANNELS, NUMSPEAKERS, RESETCHANNELS : [ReaSurroundPan] ITEMx : [ReaVerb] state configuration line, when writing should be followed by a write of DONE FILE, FILEx, -FILEx, +FILEx, -FILE* : [RS5k] file list, -/+ prefixes are write-only, when writing any, should be followed by a write of DONE MODE, RSMODE : [RS5k] general mode, resample mode VIDEO_CODE : [video processor] code force_auto_bypass : 0 or 1 - force auto-bypass plug-in on silence parallel : 0, 1 or 2 - 1=process plug-in in parallel with previous, 2=process plug-in parallel and merge MIDI instance_oversample_shift : instance oversampling shift amount, 0=none, 1=~96k, 2=~192k, etc. When setting requires playback stop/start to take effect chain_oversample_shift : chain oversampling shift amount, 0=none, 1=~96k, 2=~192k, etc. When setting requires playback stop/start to take effect chain_pdc_mode : chain PDC mode (0=classic, 1=new-default, 2=ignore PDC, 3=hwcomp-master) chain_sel : selected/visible FX in chain renamed_name : renamed FX instance name (empty string = not renamed) container_nch : number of internal channels for container container_nch_in : number of input pins for container container_nch_out : number of output pints for container container_nch_feedback : number of internal feedback channels enabled in container focused : reading returns 1 if focused. Writing a positive value to this sets the FX UI as "last focused." last_touched : reading returns two integers, one indicates whether FX is the last-touched FX, the second indicates which parameter was last touched. Writing a negative value ensures this plug-in is not set as last touched, otherwise the FX is set "last touched," and last touched parameter index is set to the value in the string (if valid). FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetNamedConfigParm(track, fx, parmname) end

---@param track MediaTrack
---@param fx integer
---@return integer
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetNumParams(track, fx) end

---@param track MediaTrack
---@param fx integer
---@return boolean
--- See TrackFX_SetOffline FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetOffline(track, fx) end

---@param track MediaTrack
---@param fx integer
---@return boolean
--- Returns true if this FX UI is open in the FX chain window or a floating window. See TrackFX_SetOpen FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetOpen(track, fx) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@return number retval, number minval, number maxval
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetParam(track, fx, param) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean retval, number step, number smallstep, number largestep, boolean istoggle
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetParameterStepSizes(track, fx, param) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@return number retval, number minval, number maxval, number midval
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetParamEx(track, fx, param) end

---@param track MediaTrack
---@param fx integer
---@param ident_str string
---@return integer
--- gets the parameter index from an identifying string (:wet, :bypass, :delta, or a string returned from GetParamIdent), or -1 if unknown. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetParamFromIdent(track, fx, ident_str) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean retval, string buf
--- gets an identifying string for the parameter FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetParamIdent(track, fx, param) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@return boolean retval, string buf
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetParamName(track, fx, param) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@return number
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetParamNormalized(track, fx, param) end

---@param tr MediaTrack
---@param fx integer
---@param isoutput integer
---@param pin integer
---@return integer retval, integer high32
--- gets the effective channel mapping bitmask for a particular pin. high32Out will be set to the high 32 bits. Add 0x1000000 to pin index in order to access the second 64 bits of mappings independent of the first 64 bits. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetPinMappings(tr, fx, isoutput, pin) end

---@param track MediaTrack
---@param fx integer
---@return boolean retval, string presetname
--- Get the name of the preset currently showing in the REAPER dropdown, or the full path to a factory preset file for VST3 plug-ins (.vstpreset). See TrackFX_SetPreset . FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetPreset(track, fx) end

---@param track MediaTrack
---@param fx integer
---@return integer retval, integer numberOfPresets
--- Returns current preset index, or -1 if error. numberOfPresetsOut will be set to total number of presets available. See TrackFX_SetPresetByIndex FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetPresetIndex(track, fx) end

---@param track MediaTrack
---@return integer
--- returns index of effect visible in record input chain, or -1 for chain hidden, or -2 for chain visible but no effect selected
function reaper.TrackFX_GetRecChainVisible(track) end

---@param track MediaTrack
---@return integer
--- returns count of record input FX. To access record input FX, use a FX indices [0x1000000..0x1000000+n). On the master track, this accesses monitoring FX rather than record input FX.
function reaper.TrackFX_GetRecCount(track) end

---@param track MediaTrack
---@param fx integer
---@return string fn
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_GetUserPresetFilename(track, fx) end

---@param track MediaTrack
---@param fx integer
---@param presetmove integer
---@return boolean
--- presetmove==1 activates the next preset, presetmove==-1 activates the previous preset, etc. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_NavigatePresets(track, fx, presetmove) end

---@param track MediaTrack
---@param fx integer
---@param enabled boolean
--- See TrackFX_GetEnabled FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetEnabled(track, fx, enabled) end

---@param track MediaTrack
---@param fxidx integer
---@param bandtype integer
---@param bandidx integer
---@param enable boolean
---@return boolean
--- Enable or disable a ReaEQ band. Returns false if track/fxidx is not ReaEQ. Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass. Bandidx (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc. See TrackFX_GetEQ , TrackFX_GetEQParam , TrackFX_SetEQParam , TrackFX_GetEQBandEnabled . FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetEQBandEnabled(track, fxidx, bandtype, bandidx, enable) end

---@param track MediaTrack
---@param fxidx integer
---@param bandtype integer
---@param bandidx integer
---@param paramtype integer
---@param val number
---@param isnorm boolean
---@return boolean
--- Returns false if track/fxidx is not ReaEQ. Targets a band matching bandtype. Bandtype: -1=master gain, 0=hipass, 1=loshelf, 2=band, 3=notch, 4=hishelf, 5=lopass, 6=bandpass, 7=parallel bandpass. Bandidx (ignored for master gain): 0=target first band matching bandtype, 1=target 2nd band matching bandtype, etc. Paramtype (ignored for master gain): 0=freq, 1=gain, 2=Q. See TrackFX_GetEQ , TrackFX_GetEQParam , TrackFX_GetEQBandEnabled , TrackFX_SetEQBandEnabled . FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetEQParam(track, fxidx, bandtype, bandidx, paramtype, val, isnorm) end

---@param track MediaTrack
---@param fx integer
---@param parmname string
---@param value string
---@return boolean
--- sets plug-in specific named configuration value (returns true on success). Support values for write: vst_chunk[_program] : base64-encoded VST-specific chunk. clap_chunk : base64-encoded CLAP-specific chunk. param.X.lfo.[active,dir,phase,speed,strength,temposync,free,shape] : parameter moduation LFO state param.X.acs.[active,dir,strength,attack,release,dblo,dbhi,chan,stereo,x2,y2] : parameter modulation ACS state param.X.plink.[active,scale,offset,effect,param,midi_bus,midi_chan,midi_msg,midi_msg2] : parameter link/MIDI link: set effect=-100 to support midi_* param.X.mod.[active,baseline,visible] : parameter module global settings param.X.learn.[midi1,midi2,osc] : first two bytes of MIDI message, or OSC string if set param.X.learn.mode : absolution/relative mode flag (0: Absolute, 1: 127=-1,1=+1, 2: 63=-1, 65=+1, 3: 65=-1, 1=+1, 4: toggle if nonzero) param.X.learn.flags : &1=selected track only, &2=soft takeover, &4=focused FX only, &8=LFO retrigger, &16=visible FX only param.X.container_map.fx_index : index of FX contained in container param.X.container_map.fx_parm : parameter index of parameter of FX contained in container param.X.container_map.aliased_name : name of parameter (if user-renamed, otherwise fails) BANDTYPEx, BANDENABLEDx : band configuration [ReaEQ] THRESHOLD, CEILING, TRUEPEAK : [ReaLimit] NUMCHANNELS, NUMSPEAKERS, RESETCHANNELS : [ReaSurroundPan] ITEMx : [ReaVerb] state configuration line, when writing should be followed by a write of DONE FILE, FILEx, -FILEx, +FILEx, -FILE* : [RS5k] file list, -/+ prefixes are write-only, when writing any, should be followed by a write of DONE MODE, RSMODE : [RS5k] general mode, resample mode VIDEO_CODE : [video processor] code force_auto_bypass : 0 or 1 - force auto-bypass plug-in on silence parallel : 0, 1 or 2 - 1=process plug-in in parallel with previous, 2=process plug-in parallel and merge MIDI instance_oversample_shift : instance oversampling shift amount, 0=none, 1=~96k, 2=~192k, etc. When setting requires playback stop/start to take effect chain_oversample_shift : chain oversampling shift amount, 0=none, 1=~96k, 2=~192k, etc. When setting requires playback stop/start to take effect chain_pdc_mode : chain PDC mode (0=classic, 1=new-default, 2=ignore PDC, 3=hwcomp-master) chain_sel : selected/visible FX in chain renamed_name : renamed FX instance name (empty string = not renamed) container_nch : number of internal channels for container container_nch_in : number of input pins for container container_nch_out : number of output pints for container container_nch_feedback : number of internal feedback channels enabled in container focused : reading returns 1 if focused. Writing a positive value to this sets the FX UI as "last focused." last_touched : reading returns two integers, one indicates whether FX is the last-touched FX, the second indicates which parameter was last touched. Writing a negative value ensures this plug-in is not set as last touched, otherwise the FX is set "last touched," and last touched parameter index is set to the value in the string (if valid). FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetNamedConfigParm(track, fx, parmname, value) end

---@param track MediaTrack
---@param fx integer
---@param offline boolean
--- See TrackFX_GetOffline FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetOffline(track, fx, offline) end

---@param track MediaTrack
---@param fx integer
---@param open boolean
--- Open this FX UI. See TrackFX_GetOpen FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetOpen(track, fx, open) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@param val number
---@return boolean
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetParam(track, fx, param, val) end

---@param track MediaTrack
---@param fx integer
---@param param integer
---@param value number
---@return boolean
--- FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetParamNormalized(track, fx, param, value) end

---@param tr MediaTrack
---@param fx integer
---@param isoutput integer
---@param pin integer
---@param low32bits integer
---@param hi32bits integer
---@return boolean
--- sets the channel mapping bitmask for a particular pin. returns false if unsupported (not all types of plug-ins support this capability). Add 0x1000000 to pin index in order to access the second 64 bits of mappings independent of the first 64 bits. FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetPinMappings(tr, fx, isoutput, pin, low32bits, hi32bits) end

---@param track MediaTrack
---@param fx integer
---@param presetname string
---@return boolean
--- Activate a preset with the name shown in the REAPER dropdown. Full paths to .vstpreset files are also supported for VST3 plug-ins. See TrackFX_GetPreset . FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetPreset(track, fx, presetname) end

---@param track MediaTrack
---@param fx integer
---@param idx integer
---@return boolean
--- Sets the preset idx, or the factory preset (idx==-2), or the default user preset (idx==-1). Returns true on success. See TrackFX_GetPresetIndex . FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_SetPresetByIndex(track, fx, idx) end

---@param track MediaTrack
---@param index integer
---@param showFlag integer
--- showflag=0 for hidechain, =1 for show chain(index valid), =2 for hide floating window(index valid), =3 for show floating window (index valid) FX indices for tracks can have 0x1000000 added to them in order to reference record input FX (normal tracks) or hardware output FX (master track). FX indices can have 0x2000000 added to them, in which case they will be used to address FX in containers. To address a container, the 1-based subitem is multiplied by one plus the count of the FX chain and added to the 1-based container item index. e.g. to address the third item in the container at the second position of the track FX chain for tr, the index would be 0x2000000 + 3*(TrackFX_GetCount(tr)+1) + 2. This can be extended to sub-containers using TrackFX_GetNamedConfigParm with container_count and similar logic. In REAPER v7.06+, you can use the much more convenient method to navigate hierarchies, see TrackFX_GetNamedConfigParm with parent_container and container_item.X.
function reaper.TrackFX_Show(track, index, showFlag) end

---@param isMinor boolean
function reaper.TrackList_AdjustWindows(isMinor) end

function reaper.TrackList_UpdateAllExternalSurfaces() end

--- call to start a new block
function reaper.Undo_BeginBlock() end

---@param proj ReaProject
--- call to start a new block
function reaper.Undo_BeginBlock2(proj) end

---@param proj ReaProject
---@return string
--- returns string of next action,if able,NULL if not
function reaper.Undo_CanRedo2(proj) end

---@param proj ReaProject
---@return string
--- returns string of last action,if able,NULL if not
function reaper.Undo_CanUndo2(proj) end

---@param proj ReaProject
---@return integer
--- nonzero if success
function reaper.Undo_DoRedo2(proj) end

---@param proj ReaProject
---@return integer
--- nonzero if success
function reaper.Undo_DoUndo2(proj) end

---@param descchange string
---@param extraflags integer
--- call to end the block,with extra flags if any,and a description
function reaper.Undo_EndBlock(descchange, extraflags) end

---@param proj ReaProject
---@param descchange string
---@param extraflags integer
--- call to end the block,with extra flags if any,and a description
function reaper.Undo_EndBlock2(proj, descchange, extraflags) end

---@param descchange string
--- limited state change to items
function reaper.Undo_OnStateChange(descchange) end

---@param proj ReaProject
---@param descchange string
--- limited state change to items
function reaper.Undo_OnStateChange2(proj, descchange) end

---@param proj ReaProject
---@param name string
---@param item MediaItem
function reaper.Undo_OnStateChange_Item(proj, name, item) end

---@param descchange string
---@param whichStates integer
---@param trackparm integer
--- trackparm=-1 by default,or if updating one fx chain,you can specify track index
function reaper.Undo_OnStateChangeEx(descchange, whichStates, trackparm) end

---@param proj ReaProject
---@param descchange string
---@param whichStates integer
---@param trackparm integer
--- trackparm=-1 by default,or if updating one fx chain,you can specify track index
function reaper.Undo_OnStateChangeEx2(proj, descchange, whichStates, trackparm) end

--- Redraw the arrange view
function reaper.UpdateArrange() end

---@param item MediaItem
function reaper.UpdateItemInProject(item) end

---@param proj ReaProject
---@return boolean
--- Recalculate lane arrangement for fixed lane tracks, including auto-removing empty lanes at the bottom of the track
function reaper.UpdateItemLanes(proj) end

--- Redraw the arrange view and ruler
function reaper.UpdateTimeline() end

---@param pointer identifier
---@param ctypename string
---@return boolean
--- see ValidatePtr2
function reaper.ValidatePtr(pointer, ctypename) end

---@param proj ReaProject
---@param pointer identifier
---@param ctypename string
---@return boolean
--- Return true if the pointer is a valid object of the right type in proj (proj is ignored if pointer is itself a project). Supported types are: ReaProject*, MediaTrack*, MediaItem*, MediaItem_Take*, TrackEnvelope* and PCM_source*.
function reaper.ValidatePtr2(proj, pointer, ctypename) end

---@param page integer
---@param pageByName string
--- Opens the prefs to a page, use pageByName if page is 0.
function reaper.ViewPrefs(page, pageByName) end

--- Adds code to be executed when the script finishes or is ended by the user. Typically used to clean up after the user terminates defer() or runloop() code.
function reaper.atexit() end

--- Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input, while the user does other tasks. Identical to runloop().Note that no undo point will be automatically created when the script finishes, unless you create it explicitly.
function reaper.defer() end

---@return integer, string, integer, integer, integer, integer, integer, string
--- Returns contextual information about the script, typically MIDI/OSC input values.val will be set to a relative or absolute value depending on mode (=0: absolute mode, >0: relative modes).resolution=127 for 7-bit resolution, =16383 for 14-bit resolution.sectionID, and cmdID will be set to -1 if the script is not part of the action list.mode, resolution and val will be set to -1 if the script was not triggered via MIDI/OSC.contextstr may be empty or one of: midi:XX[:YY] (one or two bytes hex) [wheel|hwheel|mtvert|mthorz|mtzoom|mtrot|mediakbd]:flags key:flags:keycode osc:/msg[:f=FloatValue|:s=StringValue] KBD_OnMainActionEx(flags may include V=virtkey, S=shift, A=alt/option, C=control/command, W=win/control)
function reaper.get_action_context() end

--- Copies from source (-1 = main framebuffer, or an image from gfx.loadimg() etc), using current opacity and copy mode (set with gfx.a, gfx.mode).If destx/desty are not specified, gfx.x/gfx.y will be used as the destination position.scale (1.0 is unscaled) will be used only if destw/desth are not specified.rotation is an angle in radianssrcx/srcy/srcw/srch specify the source rectangle (if omitted srcw/srch default to image size)destx/desty/destw/desth specify destination rectangle (if not specified destw/desth default to srcw/srch * scale).
function gfx.blit() end

--- Draws an arc of the circle centered at x,y, with ang1/ang2 being specified in radians.
function gfx.arc() end

--- Deprecated, use gfx.blit instead.
function gfx.blitext() end

--- Blurs the region of the screen between gfx.x,gfx.y and x,y, and updates gfx.x,gfx.y to x,y.
function gfx.blurto() end

--- Draws a circle, optionally filling/antialiasing.
function gfx.circle() end

--- Converts the coordinates x,y to screen coordinates, returns those values.
function gfx.clienttoscreen() end

--- Blits from srcimg(srcx,srcy,srcw,srch) to destination (destx,desty,destw,desth). Source texture coordinates are s/t, dsdx represents the change in s coordinate for each x pixel, dtdy represents the change in t coordinate for each y pixel, etc. dsdxdy represents the change in dsdx for each line. If usecliprect is specified and 0, then srcw/srch are ignored.
function gfx.deltablit() end

--- Call with v=-1 to query docked state, otherwise v>=0 to set docked state. State is &1 if docked, second byte is docker index (or last docker index if undocked). If wx-wh specified, additional values will be returned with the undocked window position/size
function gfx.dock() end

--- Draws the character (can be a numeric ASCII code as well), to gfx.x, gfx.y, and moves gfx.x over by the size of the character.
function gfx.drawchar() end

--- Draws the number n with ndigits of precision to gfx.x, gfx.y, and updates gfx.x to the right side of the drawing. The text height is gfx.texth.
function gfx.drawnumber() end

--- If char is 0 or omitted, returns a character from the keyboard queue, or 0 if no character is available, or -1 if the graphics window is not open. If char is specified and nonzero, that character's status will be checked, and the function will return greater than 0 if it is pressed. Note that calling gfx.getchar() at least once causes gfx.mouse_cap to reflect keyboard modifiers even when the mouse is not captured.
function gfx.getchar() end

--- Returns success,string for dropped file index idx. call gfx.dropfile(-1) to clear the list when finished.
function gfx.getdropfile() end

--- Returns current font index, and the actual font face used by this font (if available).
function gfx.getfont() end

--- Retreives the dimensions of an image specified by handle, returns w, h pair.
function gfx.getimgdim() end

--- Returns r,g,b values [0..1] of the pixel at (gfx.x,gfx.y)
function gfx.getpixel() end

--- Fills a gradient rectangle with the color and alpha specified. drdx-dadx reflect the adjustment (per-pixel) applied for each pixel moved to the right, drdy-dady are the adjustment applied for each pixel moved toward the bottom. Normally drdx=adjustamount/w, drdy=adjustamount/h, etc.
function gfx.gradrect() end

--- Initializes the graphics window with title name. Suggested width and height can be specified. If window is already open, a non-empty name will re-title window, or an empty title will resize window.
function gfx.init() end

--- Draws a line from x,y to x2,y2, and if aa is not specified or 0.5 or greater, it will be antialiased.
function gfx.line() end

--- Draws a line from gfx.x,gfx.y to x,y. If aa is 0.5 or greater, then antialiasing is used. Updates gfx.x and gfx.y to x,y.
function gfx.lineto() end

--- Returns the image index if success, otherwise -1 if failure. The image will be resized to the dimensions of the image file.
function gfx.loadimg() end

--- Returns width and height of character.
function gfx.measurechar() end

--- Returns width and height of string.
function gfx.measurestr() end

--- Multiplies each pixel by mul_* and adds add_*, and updates in-place. Useful for changing brightness/contrast, or other effects.
function gfx.muladdrect() end

--- Formats and draws a string at gfx.x, gfx.y, and updates gfx.x/gfx.y accordingly (the latter only if the formatted string contains newline). For more information on format strings, see sprintf()
function gfx.printf() end

--- Closes the graphics window. Closes the graphics window.
function gfx.quit() end

--- Fills a rectangle at x,y, w,h pixels in dimension, filled by default.
function gfx.rect() end

--- Fills a rectangle from gfx.x,gfx.y to x,y. Updates gfx.x,gfx.y to x,y.
function gfx.rectto() end

--- Draws a rectangle with rounded corners.
function gfx.roundrect() end

--- Converts the screen coordinates x,y to client coordinates, returns those values.
function gfx.screentoclient() end

--- Sets gfx.r/gfx.g/gfx.b/gfx.a/gfx.mode/gfx.a2, sets gfx.dest if final parameter specified
function gfx.set() end

--- Sets the mouse cursor to resource_id and/or custom_cursor_name.
function gfx.setcursor() end

--- Can select a font and optionally configure it. idx=0 for default bitmapped font, no configuration is possible for this font. idx=1..16 for a configurable font, specify fontface such as "Arial", sz of 8-100, and optionally specify flags, which is a multibyte character, which can include 'i' for italics, 'u' for underline, or 'b' for bold. These flags may or may not be supported depending on the font and OS. After calling gfx.setfont(), gfx.texth may be updated to reflect the new average line height.
function gfx.setfont() end

--- Resize image referenced by index 0..1024-1, width and height must be 0-8192. The contents of the image will be undefined after the resize.
function gfx.setimgdim() end

--- Writes a pixel of r,g,b to gfx.x,gfx.y.
function gfx.setpixel() end

--- Shows a popup menu at gfx.x,gfx.y. str is a list of fields separated by | characters. Each field represents a menu item.
function gfx.showmenu() end

--- Blits to destination at (destx,desty), size (destw,desth). div_w and div_h should be 2..64, and table should point to a table of 2*div_w*div_h values (table can be a regular table or (for less overhead) a reaper.array). Each pair in the table represents a S,T coordinate in the source image, and the table is treated as a left-right, top-bottom list of texture coordinates, which will then be rendered to the destination.
function gfx.transformblit() end

--- Draws a filled triangle, or any convex polygon.
function gfx.triangle() end

--- Updates the graphics display, if opened
function gfx.update() end

--- Set to empty string to detach. 6.20+: returns previous shared memory segment name.
function reaper.gmem_attach() end

--- Read (number) value from shared memory attached-to by gmem_attach(). index can be [0..1<<25).
function reaper.gmem_read() end

--- Write (number) value to shared memory attached-to by gmem_attach(). index can be [0..1<<25).
function reaper.gmem_write() end

---@param table_or_array table|any[]
---@param size integer
---@return ReaperArray
--- Creates a new reaper.array object of maximum and initial size size, if specified, or from the size/values of a table/array. Both size and table/array can be specified, the size parameter will override the table/array size.
function reaper.new_array(table_or_array, size) end

--- Adds code to be called back by REAPER. Used to create persistent ReaScripts that continue to run and respond to input, while the user does other tasks. Identical to defer().Note that no undo point will be automatically created when the script finishes, unless you create it explicitly.
function reaper.runloop() end

--- Sets action options for the script.flag&1: script will auto-terminate if re-launched while already runningflag&2: if (flag&1) is set, script will re-launch after auto-terminating. otherwise, re-launch is ignored.flag&4: set script toggle state onflag&8: set script toggle state off
function reaper.set_action_options() end
