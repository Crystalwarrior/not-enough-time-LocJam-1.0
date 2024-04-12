local path = (...):gsub("[^%.]*$", "")
local M = require(path .. "master")
local ffi = require("ffi")
local bit = require("bit")
M.FMOD_VERSION = 0x00020201
M.FMOD_DEBUG_LEVEL_NONE = 0x00000000
M.FMOD_DEBUG_LEVEL_ERROR = 0x00000001
M.FMOD_DEBUG_LEVEL_WARNING = 0x00000002
M.FMOD_DEBUG_LEVEL_LOG = 0x00000004
M.FMOD_DEBUG_TYPE_MEMORY = 0x00000100
M.FMOD_DEBUG_TYPE_FILE = 0x00000200
M.FMOD_DEBUG_TYPE_CODEC = 0x00000400
M.FMOD_DEBUG_TYPE_TRACE = 0x00000800
M.FMOD_DEBUG_DISPLAY_TIMESTAMPS = 0x00010000
M.FMOD_DEBUG_DISPLAY_LINENUMBERS = 0x00020000
M.FMOD_DEBUG_DISPLAY_THREAD = 0x00040000
M.FMOD_MEMORY_NORMAL = 0x00000000
M.FMOD_MEMORY_STREAM_FILE = 0x00000001
M.FMOD_MEMORY_STREAM_DECODE = 0x00000002
M.FMOD_MEMORY_SAMPLEDATA = 0x00000004
M.FMOD_MEMORY_DSP_BUFFER = 0x00000008
M.FMOD_MEMORY_PLUGIN = 0x00000010
M.FMOD_MEMORY_PERSISTENT = 0x00200000
M.FMOD_MEMORY_ALL = 0xFFFFFFFF
M.FMOD_INIT_NORMAL = 0x00000000
M.FMOD_INIT_STREAM_FROM_UPDATE = 0x00000001
M.FMOD_INIT_MIX_FROM_UPDATE = 0x00000002
M.FMOD_INIT_3D_RIGHTHANDED = 0x00000004
M.FMOD_INIT_CHANNEL_LOWPASS = 0x00000100
M.FMOD_INIT_CHANNEL_DISTANCEFILTER = 0x00000200
M.FMOD_INIT_PROFILE_ENABLE = 0x00010000
M.FMOD_INIT_VOL0_BECOMES_VIRTUAL = 0x00020000
M.FMOD_INIT_GEOMETRY_USECLOSEST = 0x00040000
M.FMOD_INIT_PREFER_DOLBY_DOWNMIX = 0x00080000
M.FMOD_INIT_THREAD_UNSAFE = 0x00100000
M.FMOD_INIT_PROFILE_METER_ALL = 0x00200000
M.FMOD_INIT_MEMORY_TRACKING = 0x00400000
M.FMOD_DRIVER_STATE_CONNECTED = 0x00000001
M.FMOD_DRIVER_STATE_DEFAULT = 0x00000002
M.FMOD_TIMEUNIT_MS = 0x00000001
M.FMOD_TIMEUNIT_PCM = 0x00000002
M.FMOD_TIMEUNIT_PCMBYTES = 0x00000004
M.FMOD_TIMEUNIT_RAWBYTES = 0x00000008
M.FMOD_TIMEUNIT_PCMFRACTION = 0x00000010
M.FMOD_TIMEUNIT_MODORDER = 0x00000100
M.FMOD_TIMEUNIT_MODROW = 0x00000200
M.FMOD_TIMEUNIT_MODPATTERN = 0x00000400
M.FMOD_SYSTEM_CALLBACK_DEVICELISTCHANGED = 0x00000001
M.FMOD_SYSTEM_CALLBACK_DEVICELOST = 0x00000002
M.FMOD_SYSTEM_CALLBACK_MEMORYALLOCATIONFAILED = 0x00000004
M.FMOD_SYSTEM_CALLBACK_THREADCREATED = 0x00000008
M.FMOD_SYSTEM_CALLBACK_BADDSPCONNECTION = 0x00000010
M.FMOD_SYSTEM_CALLBACK_PREMIX = 0x00000020
M.FMOD_SYSTEM_CALLBACK_POSTMIX = 0x00000040
M.FMOD_SYSTEM_CALLBACK_ERROR = 0x00000080
M.FMOD_SYSTEM_CALLBACK_MIDMIX = 0x00000100
M.FMOD_SYSTEM_CALLBACK_THREADDESTROYED = 0x00000200
M.FMOD_SYSTEM_CALLBACK_PREUPDATE = 0x00000400
M.FMOD_SYSTEM_CALLBACK_POSTUPDATE = 0x00000800
M.FMOD_SYSTEM_CALLBACK_RECORDLISTCHANGED = 0x00001000
M.FMOD_SYSTEM_CALLBACK_BUFFEREDNOMIX = 0x00002000
M.FMOD_SYSTEM_CALLBACK_DEVICEREINITIALIZE = 0x00004000
M.FMOD_SYSTEM_CALLBACK_OUTPUTUNDERRUN = 0x00008000
M.FMOD_SYSTEM_CALLBACK_ALL = 0xFFFFFFFF
M.FMOD_DEFAULT = 0x00000000
M.FMOD_LOOP_OFF = 0x00000001
M.FMOD_LOOP_NORMAL = 0x00000002
M.FMOD_LOOP_BIDI = 0x00000004
M.FMOD_2D = 0x00000008
M.FMOD_3D = 0x00000010
M.FMOD_CREATESTREAM = 0x00000080
M.FMOD_CREATESAMPLE = 0x00000100
M.FMOD_CREATECOMPRESSEDSAMPLE = 0x00000200
M.FMOD_OPENUSER = 0x00000400
M.FMOD_OPENMEMORY = 0x00000800
M.FMOD_OPENMEMORY_POINT = 0x10000000
M.FMOD_OPENRAW = 0x00001000
M.FMOD_OPENONLY = 0x00002000
M.FMOD_ACCURATETIME = 0x00004000
M.FMOD_MPEGSEARCH = 0x00008000
M.FMOD_NONBLOCKING = 0x00010000
M.FMOD_UNIQUE = 0x00020000
M.FMOD_3D_HEADRELATIVE = 0x00040000
M.FMOD_3D_WORLDRELATIVE = 0x00080000
M.FMOD_3D_INVERSEROLLOFF = 0x00100000
M.FMOD_3D_LINEARROLLOFF = 0x00200000
M.FMOD_3D_LINEARSQUAREROLLOFF = 0x00400000
M.FMOD_3D_INVERSETAPEREDROLLOFF = 0x00800000
M.FMOD_3D_CUSTOMROLLOFF = 0x04000000
M.FMOD_3D_IGNOREGEOMETRY = 0x40000000
M.FMOD_IGNORETAGS = 0x02000000
M.FMOD_LOWMEM = 0x08000000
M.FMOD_VIRTUAL_PLAYFROMSTART = 0x80000000
M.FMOD_CHANNELMASK_FRONT_LEFT = 0x00000001
M.FMOD_CHANNELMASK_FRONT_RIGHT = 0x00000002
M.FMOD_CHANNELMASK_FRONT_CENTER = 0x00000004
M.FMOD_CHANNELMASK_LOW_FREQUENCY = 0x00000008
M.FMOD_CHANNELMASK_SURROUND_LEFT = 0x00000010
M.FMOD_CHANNELMASK_SURROUND_RIGHT = 0x00000020
M.FMOD_CHANNELMASK_BACK_LEFT = 0x00000040
M.FMOD_CHANNELMASK_BACK_RIGHT = 0x00000080
M.FMOD_CHANNELMASK_BACK_CENTER = 0x00000100
M.FMOD_CHANNELMASK_MONO = bit.bor(M.FMOD_CHANNELMASK_FRONT_LEFT)
M.FMOD_CHANNELMASK_STEREO = bit.bor(M.FMOD_CHANNELMASK_FRONT_LEFT,M.FMOD_CHANNELMASK_FRONT_RIGHT)
M.FMOD_CHANNELMASK_LRC = bit.bor(M.FMOD_CHANNELMASK_FRONT_LEFT,M.FMOD_CHANNELMASK_FRONT_RIGHT,M.FMOD_CHANNELMASK_FRONT_CENTER)
M.FMOD_CHANNELMASK_QUAD = bit.bor(M.FMOD_CHANNELMASK_FRONT_LEFT,M.FMOD_CHANNELMASK_FRONT_RIGHT,M.FMOD_CHANNELMASK_SURROUND_LEFT,M.FMOD_CHANNELMASK_SURROUND_RIGHT)
M.FMOD_CHANNELMASK_SURROUND = bit.bor(M.FMOD_CHANNELMASK_FRONT_LEFT,M.FMOD_CHANNELMASK_FRONT_RIGHT,M.FMOD_CHANNELMASK_FRONT_CENTER,M.FMOD_CHANNELMASK_SURROUND_LEFT,M.FMOD_CHANNELMASK_SURROUND_RIGHT)
M.FMOD_CHANNELMASK_5POINT1 = bit.bor(M.FMOD_CHANNELMASK_FRONT_LEFT,M.FMOD_CHANNELMASK_FRONT_RIGHT,M.FMOD_CHANNELMASK_FRONT_CENTER,M.FMOD_CHANNELMASK_LOW_FREQUENCY,M.FMOD_CHANNELMASK_SURROUND_LEFT,M.FMOD_CHANNELMASK_SURROUND_RIGHT)
M.FMOD_CHANNELMASK_5POINT1_REARS = bit.bor(M.FMOD_CHANNELMASK_FRONT_LEFT,M.FMOD_CHANNELMASK_FRONT_RIGHT,M.FMOD_CHANNELMASK_FRONT_CENTER,M.FMOD_CHANNELMASK_LOW_FREQUENCY,M.FMOD_CHANNELMASK_BACK_LEFT,M.FMOD_CHANNELMASK_BACK_RIGHT)
M.FMOD_CHANNELMASK_7POINT0 = bit.bor(M.FMOD_CHANNELMASK_FRONT_LEFT,M.FMOD_CHANNELMASK_FRONT_RIGHT,M.FMOD_CHANNELMASK_FRONT_CENTER,M.FMOD_CHANNELMASK_SURROUND_LEFT,M.FMOD_CHANNELMASK_SURROUND_RIGHT,M.FMOD_CHANNELMASK_BACK_LEFT,M.FMOD_CHANNELMASK_BACK_RIGHT)
M.FMOD_CHANNELMASK_7POINT1 = bit.bor(M.FMOD_CHANNELMASK_FRONT_LEFT,M.FMOD_CHANNELMASK_FRONT_RIGHT,M.FMOD_CHANNELMASK_FRONT_CENTER,M.FMOD_CHANNELMASK_LOW_FREQUENCY,M.FMOD_CHANNELMASK_SURROUND_LEFT,M.FMOD_CHANNELMASK_SURROUND_RIGHT,M.FMOD_CHANNELMASK_BACK_LEFT,M.FMOD_CHANNELMASK_BACK_RIGHT)
M.FMOD_THREAD_PRIORITY_PLATFORM_MIN = -32*1024
M.FMOD_THREAD_PRIORITY_PLATFORM_MAX = 32*1024
M.FMOD_THREAD_PRIORITY_DEFAULT = (M.FMOD_THREAD_PRIORITY_PLATFORM_MIN-1)
M.FMOD_THREAD_PRIORITY_LOW = (M.FMOD_THREAD_PRIORITY_PLATFORM_MIN-2)
M.FMOD_THREAD_PRIORITY_MEDIUM = (M.FMOD_THREAD_PRIORITY_PLATFORM_MIN-3)
M.FMOD_THREAD_PRIORITY_HIGH = (M.FMOD_THREAD_PRIORITY_PLATFORM_MIN-4)
M.FMOD_THREAD_PRIORITY_VERY_HIGH = (M.FMOD_THREAD_PRIORITY_PLATFORM_MIN-5)
M.FMOD_THREAD_PRIORITY_EXTREME = (M.FMOD_THREAD_PRIORITY_PLATFORM_MIN-6)
M.FMOD_THREAD_PRIORITY_CRITICAL = (M.FMOD_THREAD_PRIORITY_PLATFORM_MIN-7)
M.FMOD_THREAD_PRIORITY_MIXER = M.FMOD_THREAD_PRIORITY_EXTREME
M.FMOD_THREAD_PRIORITY_FEEDER = M.FMOD_THREAD_PRIORITY_CRITICAL
M.FMOD_THREAD_PRIORITY_STREAM = M.FMOD_THREAD_PRIORITY_VERY_HIGH
M.FMOD_THREAD_PRIORITY_FILE = M.FMOD_THREAD_PRIORITY_HIGH
M.FMOD_THREAD_PRIORITY_NONBLOCKING = M.FMOD_THREAD_PRIORITY_HIGH
M.FMOD_THREAD_PRIORITY_RECORD = M.FMOD_THREAD_PRIORITY_HIGH
M.FMOD_THREAD_PRIORITY_GEOMETRY = M.FMOD_THREAD_PRIORITY_LOW
M.FMOD_THREAD_PRIORITY_PROFILER = M.FMOD_THREAD_PRIORITY_MEDIUM
M.FMOD_THREAD_PRIORITY_STUDIO_UPDATE = M.FMOD_THREAD_PRIORITY_MEDIUM
M.FMOD_THREAD_PRIORITY_STUDIO_LOAD_BANK = M.FMOD_THREAD_PRIORITY_MEDIUM
M.FMOD_THREAD_PRIORITY_STUDIO_LOAD_SAMPLE = M.FMOD_THREAD_PRIORITY_MEDIUM
M.FMOD_THREAD_PRIORITY_CONVOLUTION1 = M.FMOD_THREAD_PRIORITY_VERY_HIGH
M.FMOD_THREAD_PRIORITY_CONVOLUTION2 = M.FMOD_THREAD_PRIORITY_VERY_HIGH
M.FMOD_THREAD_STACK_SIZE_DEFAULT = 0
M.FMOD_THREAD_STACK_SIZE_MIXER = 80*1024
M.FMOD_THREAD_STACK_SIZE_FEEDER = 16*1024
M.FMOD_THREAD_STACK_SIZE_STREAM = 96*1024
M.FMOD_THREAD_STACK_SIZE_FILE = 48*1024
M.FMOD_THREAD_STACK_SIZE_NONBLOCKING = 112*1024
M.FMOD_THREAD_STACK_SIZE_RECORD = 16*1024
M.FMOD_THREAD_STACK_SIZE_GEOMETRY = 48*1024
M.FMOD_THREAD_STACK_SIZE_PROFILER = 128*1024
M.FMOD_THREAD_STACK_SIZE_STUDIO_UPDATE = 96*1024
M.FMOD_THREAD_STACK_SIZE_STUDIO_LOAD_BANK = 96*1024
M.FMOD_THREAD_STACK_SIZE_STUDIO_LOAD_SAMPLE = 96*1024
M.FMOD_THREAD_STACK_SIZE_CONVOLUTION1 = 16*1024
M.FMOD_THREAD_STACK_SIZE_CONVOLUTION2 = 16*1024
M.FMOD_THREAD_AFFINITY_GROUP_DEFAULT = 0x4000000000000000LL
M.FMOD_THREAD_AFFINITY_GROUP_A = 0x4000000000000001LL
M.FMOD_THREAD_AFFINITY_GROUP_B = 0x4000000000000002LL
M.FMOD_THREAD_AFFINITY_GROUP_C = 0x4000000000000003LL
M.FMOD_THREAD_AFFINITY_MIXER = M.FMOD_THREAD_AFFINITY_GROUP_A
M.FMOD_THREAD_AFFINITY_FEEDER = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_STREAM = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_FILE = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_NONBLOCKING = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_RECORD = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_GEOMETRY = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_PROFILER = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_STUDIO_UPDATE = M.FMOD_THREAD_AFFINITY_GROUP_B
M.FMOD_THREAD_AFFINITY_STUDIO_LOAD_BANK = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_STUDIO_LOAD_SAMPLE = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_CONVOLUTION1 = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_CONVOLUTION2 = M.FMOD_THREAD_AFFINITY_GROUP_C
M.FMOD_THREAD_AFFINITY_CORE_ALL = 0
M.FMOD_THREAD_AFFINITY_CORE_0 = bit.lshift(1,0)
M.FMOD_THREAD_AFFINITY_CORE_1 = bit.lshift(1,1)
M.FMOD_THREAD_AFFINITY_CORE_2 = bit.lshift(1,2)
M.FMOD_THREAD_AFFINITY_CORE_3 = bit.lshift(1,3)
M.FMOD_THREAD_AFFINITY_CORE_4 = bit.lshift(1,4)
M.FMOD_THREAD_AFFINITY_CORE_5 = bit.lshift(1,5)
M.FMOD_THREAD_AFFINITY_CORE_6 = bit.lshift(1,6)
M.FMOD_THREAD_AFFINITY_CORE_7 = bit.lshift(1,7)
M.FMOD_THREAD_AFFINITY_CORE_8 = bit.lshift(1,8)
M.FMOD_THREAD_AFFINITY_CORE_9 = bit.lshift(1,9)
M.FMOD_THREAD_AFFINITY_CORE_10 = bit.lshift(1,10)
M.FMOD_THREAD_AFFINITY_CORE_11 = bit.lshift(1,11)
M.FMOD_THREAD_AFFINITY_CORE_12 = bit.lshift(1,12)
M.FMOD_THREAD_AFFINITY_CORE_13 = bit.lshift(1,13)
M.FMOD_THREAD_AFFINITY_CORE_14 = bit.lshift(1,14)
M.FMOD_THREAD_AFFINITY_CORE_15 = bit.lshift(1,15)
M.FMOD_PRESET_OFF = ffi.new("FMOD_REVERB_PROPERTIES", 1000,7,11,5000,100,100,100,250,0,20,96,-80.0)
M.FMOD_PRESET_GENERIC = ffi.new("FMOD_REVERB_PROPERTIES", 1500,7,11,5000,83,100,100,250,0,14500,96,-8.0)
M.FMOD_PRESET_PADDEDCELL = ffi.new("FMOD_REVERB_PROPERTIES", 170,1,2,5000,10,100,100,250,0,160,84,-7.8)
M.FMOD_PRESET_ROOM = ffi.new("FMOD_REVERB_PROPERTIES", 400,2,3,5000,83,100,100,250,0,6050,88,-9.4)
M.FMOD_PRESET_BATHROOM = ffi.new("FMOD_REVERB_PROPERTIES", 1500,7,11,5000,54,100,60,250,0,2900,83,0.5)
M.FMOD_PRESET_LIVINGROOM = ffi.new("FMOD_REVERB_PROPERTIES", 500,3,4,5000,10,100,100,250,0,160,58,-19.0)
M.FMOD_PRESET_STONEROOM = ffi.new("FMOD_REVERB_PROPERTIES", 2300,12,17,5000,64,100,100,250,0,7800,71,-8.5)
M.FMOD_PRESET_AUDITORIUM = ffi.new("FMOD_REVERB_PROPERTIES", 4300,20,30,5000,59,100,100,250,0,5850,64,-11.7)
M.FMOD_PRESET_CONCERTHALL = ffi.new("FMOD_REVERB_PROPERTIES", 3900,20,29,5000,70,100,100,250,0,5650,80,-9.8)
M.FMOD_PRESET_CAVE = ffi.new("FMOD_REVERB_PROPERTIES", 2900,15,22,5000,100,100,100,250,0,20000,59,-11.3)
M.FMOD_PRESET_ARENA = ffi.new("FMOD_REVERB_PROPERTIES", 7200,20,30,5000,33,100,100,250,0,4500,80,-9.6)
M.FMOD_PRESET_HANGAR = ffi.new("FMOD_REVERB_PROPERTIES", 10000,20,30,5000,23,100,100,250,0,3400,72,-7.4)
M.FMOD_PRESET_CARPETTEDHALLWAY = ffi.new("FMOD_REVERB_PROPERTIES", 300,2,30,5000,10,100,100,250,0,500,56,-24.0)
M.FMOD_PRESET_HALLWAY = ffi.new("FMOD_REVERB_PROPERTIES", 1500,7,11,5000,59,100,100,250,0,7800,87,-5.5)
M.FMOD_PRESET_STONECORRIDOR = ffi.new("FMOD_REVERB_PROPERTIES", 270,13,20,5000,79,100,100,250,0,9000,86,-6.0)
M.FMOD_PRESET_ALLEY = ffi.new("FMOD_REVERB_PROPERTIES", 1500,7,11,5000,86,100,100,250,0,8300,80,-9.8)
M.FMOD_PRESET_FOREST = ffi.new("FMOD_REVERB_PROPERTIES", 1500,162,88,5000,54,79,100,250,0,760,94,-12.3)
M.FMOD_PRESET_CITY = ffi.new("FMOD_REVERB_PROPERTIES", 1500,7,11,5000,67,50,100,250,0,4050,66,-26.0)
M.FMOD_PRESET_MOUNTAINS = ffi.new("FMOD_REVERB_PROPERTIES", 1500,300,100,5000,21,27,100,250,0,1220,82,-24.0)
M.FMOD_PRESET_QUARRY = ffi.new("FMOD_REVERB_PROPERTIES", 1500,61,25,5000,83,100,100,250,0,3400,100,-5.0)
M.FMOD_PRESET_PLAIN = ffi.new("FMOD_REVERB_PROPERTIES", 1500,179,100,5000,50,21,100,250,0,1670,65,-28.0)
M.FMOD_PRESET_PARKINGLOT = ffi.new("FMOD_REVERB_PROPERTIES", 1700,8,12,5000,100,100,100,250,0,20000,56,-19.5)
M.FMOD_PRESET_SEWERPIPE = ffi.new("FMOD_REVERB_PROPERTIES", 2800,14,21,5000,14,80,60,250,0,3400,66,1.2)
M.FMOD_PRESET_UNDERWATER = ffi.new("FMOD_REVERB_PROPERTIES", 1500,7,11,5000,10,100,100,250,0,500,92,7.0)
M.FMOD_MAX_CHANNEL_WIDTH = 32
M.FMOD_MAX_SYSTEMS = 8
M.FMOD_MAX_LISTENERS = 8
M.FMOD_REVERB_MAXINSTANCES = 4
M.FMOD_PORT_INDEX_NONE = 0xFFFFFFFFFFFFFFFFLL
M.FMOD_CODEC_PLUGIN_VERSION = 1
M.FMOD_CODEC_SEEK_METHOD_SET = 0
M.FMOD_CODEC_SEEK_METHOD_CURRENT = 1
M.FMOD_CODEC_SEEK_METHOD_END = 2
M.FMOD_DSP_LOUDNESS_METER_HISTOGRAM_SAMPLES = 66
M.FMOD_PLUGIN_SDK_VERSION = 110
M.FMOD_DSP_GETPARAM_VALUESTR_LENGTH = 32
M.FMOD_OUTPUT_PLUGIN_VERSION = 5
M.FMOD_OUTPUT_METHOD_MIX_DIRECT = 0
M.FMOD_OUTPUT_METHOD_MIX_BUFFERED = 1
M.FMOD_STUDIO_LOAD_MEMORY_ALIGNMENT = 32
M.FMOD_STUDIO_INIT_NORMAL = 0x00000000
M.FMOD_STUDIO_INIT_LIVEUPDATE = 0x00000001
M.FMOD_STUDIO_INIT_ALLOW_MISSING_PLUGINS = 0x00000002
M.FMOD_STUDIO_INIT_SYNCHRONOUS_UPDATE = 0x00000004
M.FMOD_STUDIO_INIT_DEFERRED_CALLBACKS = 0x00000008
M.FMOD_STUDIO_INIT_LOAD_FROM_UPDATE = 0x00000010
M.FMOD_STUDIO_INIT_MEMORY_TRACKING = 0x00000020
M.FMOD_STUDIO_PARAMETER_READONLY = 0x00000001
M.FMOD_STUDIO_PARAMETER_AUTOMATIC = 0x00000002
M.FMOD_STUDIO_PARAMETER_GLOBAL = 0x00000004
M.FMOD_STUDIO_PARAMETER_DISCRETE = 0x00000008
M.FMOD_STUDIO_PARAMETER_LABELED = 0x00000010
M.FMOD_STUDIO_SYSTEM_CALLBACK_PREUPDATE = 0x00000001
M.FMOD_STUDIO_SYSTEM_CALLBACK_POSTUPDATE = 0x00000002
M.FMOD_STUDIO_SYSTEM_CALLBACK_BANK_UNLOAD = 0x00000004
M.FMOD_STUDIO_SYSTEM_CALLBACK_LIVEUPDATE_CONNECTED = 0x00000008
M.FMOD_STUDIO_SYSTEM_CALLBACK_LIVEUPDATE_DISCONNECTED = 0x00000010
M.FMOD_STUDIO_SYSTEM_CALLBACK_ALL = 0xFFFFFFFF
M.FMOD_STUDIO_EVENT_CALLBACK_CREATED = 0x00000001
M.FMOD_STUDIO_EVENT_CALLBACK_DESTROYED = 0x00000002
M.FMOD_STUDIO_EVENT_CALLBACK_STARTING = 0x00000004
M.FMOD_STUDIO_EVENT_CALLBACK_STARTED = 0x00000008
M.FMOD_STUDIO_EVENT_CALLBACK_RESTARTED = 0x00000010
M.FMOD_STUDIO_EVENT_CALLBACK_STOPPED = 0x00000020
M.FMOD_STUDIO_EVENT_CALLBACK_START_FAILED = 0x00000040
M.FMOD_STUDIO_EVENT_CALLBACK_CREATE_PROGRAMMER_SOUND = 0x00000080
M.FMOD_STUDIO_EVENT_CALLBACK_DESTROY_PROGRAMMER_SOUND = 0x00000100
M.FMOD_STUDIO_EVENT_CALLBACK_PLUGIN_CREATED = 0x00000200
M.FMOD_STUDIO_EVENT_CALLBACK_PLUGIN_DESTROYED = 0x00000400
M.FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_MARKER = 0x00000800
M.FMOD_STUDIO_EVENT_CALLBACK_TIMELINE_BEAT = 0x00001000
M.FMOD_STUDIO_EVENT_CALLBACK_SOUND_PLAYED = 0x00002000
M.FMOD_STUDIO_EVENT_CALLBACK_SOUND_STOPPED = 0x00004000
M.FMOD_STUDIO_EVENT_CALLBACK_REAL_TO_VIRTUAL = 0x00008000
M.FMOD_STUDIO_EVENT_CALLBACK_VIRTUAL_TO_REAL = 0x00010000
M.FMOD_STUDIO_EVENT_CALLBACK_START_EVENT_COMMAND = 0x00020000
M.FMOD_STUDIO_EVENT_CALLBACK_NESTED_TIMELINE_BEAT = 0x00040000
M.FMOD_STUDIO_EVENT_CALLBACK_ALL = 0xFFFFFFFF
M.FMOD_STUDIO_LOAD_BANK_NORMAL = 0x00000000
M.FMOD_STUDIO_LOAD_BANK_NONBLOCKING = 0x00000001
M.FMOD_STUDIO_LOAD_BANK_DECOMPRESS_SAMPLES = 0x00000002
M.FMOD_STUDIO_LOAD_BANK_UNENCRYPTED = 0x00000004
M.FMOD_STUDIO_COMMANDCAPTURE_NORMAL = 0x00000000
M.FMOD_STUDIO_COMMANDCAPTURE_FILEFLUSH = 0x00000001
M.FMOD_STUDIO_COMMANDCAPTURE_SKIP_INITIAL_STATE = 0x00000002
M.FMOD_STUDIO_COMMANDREPLAY_NORMAL = 0x00000000
M.FMOD_STUDIO_COMMANDREPLAY_SKIP_CLEANUP = 0x00000001
M.FMOD_STUDIO_COMMANDREPLAY_FAST_FORWARD = 0x00000002
M.FMOD_STUDIO_COMMANDREPLAY_SKIP_BANK_LOAD = 0x00000004