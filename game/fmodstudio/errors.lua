local path = (...):gsub("[^%.]*$", "")
local M = require(path .. "master")

M.ErrorString = function(e)
    if e == M.FMOD_OK then return "No errors." end
    if e == M.FMOD_ERR_BADCOMMAND then return "Tried to call a function on a data type that does not allow this type of functionality (ie calling Sound::lock on a streaming sound)." end
    if e == M.FMOD_ERR_CHANNEL_ALLOC then return "Error trying to allocate a channel." end
    if e == M.FMOD_ERR_CHANNEL_STOLEN then return "The specified channel has been reused to play another sound." end
    if e == M.FMOD_ERR_DMA then return "DMA Failure.  See debug output for more information." end
    if e == M.FMOD_ERR_DSP_CONNECTION then return "DSP connection error.  Connection possibly caused a cyclic dependency or connected dsps with incompatible buffer counts." end
    if e == M.FMOD_ERR_DSP_DONTPROCESS then return "DSP return code from a DSP process query callback.  Tells mixer not to call the process callback and therefore not consume CPU.  Use this to optimize the DSP graph." end
    if e == M.FMOD_ERR_DSP_FORMAT then return "DSP Format error.  A DSP unit may have attempted to connect to this network with the wrong format, or a matrix may have been set with the wrong size if the target unit has a specified channel map." end
    if e == M.FMOD_ERR_DSP_INUSE then return "DSP is already in the mixer's DSP network. It must be removed before being reinserted or released." end
    if e == M.FMOD_ERR_DSP_NOTFOUND then return "DSP connection error.  Couldn't find the DSP unit specified." end
    if e == M.FMOD_ERR_DSP_RESERVED then return "DSP operation error.  Cannot perform operation on this DSP as it is reserved by the system." end
    if e == M.FMOD_ERR_DSP_SILENCE then return "DSP return code from a DSP process query callback.  Tells mixer silence would be produced from read, so go idle and not consume CPU.  Use this to optimize the DSP graph." end
    if e == M.FMOD_ERR_DSP_TYPE then return "DSP operation cannot be performed on a DSP of this type." end
    if e == M.FMOD_ERR_FILE_BAD then return "Error loading file." end
    if e == M.FMOD_ERR_FILE_COULDNOTSEEK then return "Couldn't perform seek operation.  This is a limitation of the medium (ie netstreams) or the file format." end
    if e == M.FMOD_ERR_FILE_DISKEJECTED then return "Media was ejected while reading." end
    if e == M.FMOD_ERR_FILE_EOF then return "End of file unexpectedly reached while trying to read essential data (truncated?)." end
    if e == M.FMOD_ERR_FILE_ENDOFDATA then return "End of current chunk reached while trying to read data." end
    if e == M.FMOD_ERR_FILE_NOTFOUND then return "File not found." end
    if e == M.FMOD_ERR_FORMAT then return "Unsupported file or audio format." end
    if e == M.FMOD_ERR_HEADER_MISMATCH then return "There is a version mismatch between the FMOD header and either the FMOD Studio library or the FMOD Low Level library." end
    if e == M.FMOD_ERR_HTTP then return "A HTTP error occurred. This is a catch-all for HTTP errors not listed elsewhere." end
    if e == M.FMOD_ERR_HTTP_ACCESS then return "The specified resource requires authentication or is forbidden." end
    if e == M.FMOD_ERR_HTTP_PROXY_AUTH then return "Proxy authentication is required to access the specified resource." end
    if e == M.FMOD_ERR_HTTP_SERVER_ERROR then return "A HTTP server error occurred." end
    if e == M.FMOD_ERR_HTTP_TIMEOUT then return "The HTTP request timed out." end
    if e == M.FMOD_ERR_INITIALIZATION then return "FMOD was not initialized correctly to support this function." end
    if e == M.FMOD_ERR_INITIALIZED then return "Cannot call this command after System::init." end
    if e == M.FMOD_ERR_INTERNAL then return "An error occurred that wasn't supposed to.  Contact support." end
    if e == M.FMOD_ERR_INVALID_FLOAT then return "Value passed in was a NaN, Inf or denormalized float." end
    if e == M.FMOD_ERR_INVALID_HANDLE then return "An invalid object handle was used." end
    if e == M.FMOD_ERR_INVALID_PARAM then return "An invalid parameter was passed to this function." end
    if e == M.FMOD_ERR_INVALID_POSITION then return "An invalid seek position was passed to this function." end
    if e == M.FMOD_ERR_INVALID_SPEAKER then return "An invalid speaker was passed to this function based on the current speaker mode." end
    if e == M.FMOD_ERR_INVALID_SYNCPOINT then return "The syncpoint did not come from this sound handle." end
    if e == M.FMOD_ERR_INVALID_THREAD then return "Tried to call a function on a thread that is not supported." end
    if e == M.FMOD_ERR_INVALID_VECTOR then return "The vectors passed in are not unit length, or perpendicular." end
    if e == M.FMOD_ERR_MAXAUDIBLE then return "Reached maximum audible playback count for this sound's soundgroup." end
    if e == M.FMOD_ERR_MEMORY then return "Not enough memory or resources." end
    if e == M.FMOD_ERR_MEMORY_CANTPOINT then return "Can't use FMOD_OPENMEMORY_POINT on non PCM source data, or non mp3/xma/adpcm data if FMOD_CREATECOMPRESSEDSAMPLE was used." end
    if e == M.FMOD_ERR_NEEDS3D then return "Tried to call a command on a 2d sound when the command was meant for 3d sound." end
    if e == M.FMOD_ERR_NEEDSHARDWARE then return "Tried to use a feature that requires hardware support." end
    if e == M.FMOD_ERR_NET_CONNECT then return "Couldn't connect to the specified host." end
    if e == M.FMOD_ERR_NET_SOCKET_ERROR then return "A socket error occurred.  This is a catch-all for socket-related errors not listed elsewhere." end
    if e == M.FMOD_ERR_NET_URL then return "The specified URL couldn't be resolved." end
    if e == M.FMOD_ERR_NET_WOULD_BLOCK then return "Operation on a non-blocking socket could not complete immediately." end
    if e == M.FMOD_ERR_NOTREADY then return "Operation could not be performed because specified sound/DSP connection is not ready." end
    if e == M.FMOD_ERR_OUTPUT_ALLOCATED then return "Error initializing output device, but more specifically, the output device is already in use and cannot be reused." end
    if e == M.FMOD_ERR_OUTPUT_CREATEBUFFER then return "Error creating hardware sound buffer." end
    if e == M.FMOD_ERR_OUTPUT_DRIVERCALL then return "A call to a standard soundcard driver failed, which could possibly mean a bug in the driver or resources were missing or exhausted." end
    if e == M.FMOD_ERR_OUTPUT_FORMAT then return "Soundcard does not support the specified format." end
    if e == M.FMOD_ERR_OUTPUT_INIT then return "Error initializing output device." end
    if e == M.FMOD_ERR_OUTPUT_NODRIVERS then return "The output device has no drivers installed.  If pre-init, FMOD_OUTPUT_NOSOUND is selected as the output mode.  If post-init, the function just fails." end
    if e == M.FMOD_ERR_PLUGIN then return "An unspecified error has been returned from a plugin." end
    if e == M.FMOD_ERR_PLUGIN_MISSING then return "A requested output, dsp unit type or codec was not available." end
    if e == M.FMOD_ERR_PLUGIN_RESOURCE then return "A resource that the plugin requires cannot be found. (ie the DLS file for MIDI playback)" end
    if e == M.FMOD_ERR_PLUGIN_VERSION then return "A plugin was built with an unsupported SDK version." end
    if e == M.FMOD_ERR_RECORD then return "An error occurred trying to initialize the recording device." end
    if e == M.FMOD_ERR_REVERB_CHANNELGROUP then return "Reverb properties cannot be set on this channel because a parent channelgroup owns the reverb connection." end
    if e == M.FMOD_ERR_REVERB_INSTANCE then return "Specified instance in FMOD_REVERB_PROPERTIES couldn't be set. Most likely because it is an invalid instance number or the reverb doesn't exist." end
    if e == M.FMOD_ERR_SUBSOUNDS then return "The error occurred because the sound referenced contains subsounds when it shouldn't have, or it doesn't contain subsounds when it should have.  The operation may also not be able to be performed on a parent sound." end
    if e == M.FMOD_ERR_SUBSOUND_ALLOCATED then return "This subsound is already being used by another sound, you cannot have more than one parent to a sound.  Null out the other parent's entry first." end
    if e == M.FMOD_ERR_SUBSOUND_CANTMOVE then return "Shared subsounds cannot be replaced or moved from their parent stream, such as when the parent stream is an FSB file." end
    if e == M.FMOD_ERR_TAGNOTFOUND then return "The specified tag could not be found or there are no tags." end
    if e == M.FMOD_ERR_TOOMANYCHANNELS then return "The sound created exceeds the allowable input channel count.  This can be increased using the 'maxinputchannels' parameter in System::setSoftwareFormat." end
    if e == M.FMOD_ERR_TRUNCATED then return "The retrieved string is too long to fit in the supplied buffer and has been truncated." end
    if e == M.FMOD_ERR_UNIMPLEMENTED then return "Something in FMOD hasn't been implemented when it should be! contact support!" end
    if e == M.FMOD_ERR_UNINITIALIZED then return "This command failed because System::init or System::setDriver was not called." end
    if e == M.FMOD_ERR_UNSUPPORTED then return "A command issued was not supported by this object.  Possibly a plugin without certain callbacks specified." end
    if e == M.FMOD_ERR_VERSION then return "The version number of this file format is not supported." end
    if e == M.FMOD_ERR_EVENT_ALREADY_LOADED then return "The specified bank has already been loaded." end
    if e == M.FMOD_ERR_EVENT_LIVEUPDATE_BUSY then return "The live update connection failed due to the game already being connected." end
    if e == M.FMOD_ERR_EVENT_LIVEUPDATE_MISMATCH then return "The live update connection failed due to the game data being out of sync with the tool." end
    if e == M.FMOD_ERR_EVENT_LIVEUPDATE_TIMEOUT then return "The live update connection timed out." end
    if e == M.FMOD_ERR_EVENT_NOTFOUND then return "The requested event, parameter, bus or vca could not be found." end
    if e == M.FMOD_ERR_STUDIO_UNINITIALIZED then return "The Studio::System object is not yet initialized." end
    if e == M.FMOD_ERR_STUDIO_NOT_LOADED then return "The specified resource is not loaded, so it can't be unloaded." end
    if e == M.FMOD_ERR_INVALID_STRING then return "An invalid string was passed to this function." end
    if e == M.FMOD_ERR_ALREADY_LOCKED then return "The specified resource is already locked." end
    if e == M.FMOD_ERR_NOT_LOCKED then return "The specified resource is not locked, so it can't be unlocked." end
    if e == M.FMOD_ERR_RECORD_DISCONNECTED then return "The specified recording driver has been disconnected." end
    if e == M.FMOD_ERR_TOOMANYSAMPLES then return "The length provided exceeds the allowable limit." end
end