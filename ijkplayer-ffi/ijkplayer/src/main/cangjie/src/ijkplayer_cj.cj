/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ijkplayer4cj


 let messageCallBack: CFunc<(Int32, Int32, Int32, CString, Int32) -> Unit> = {
            what, arg1, arg2, obj, id =>
            LogUtils.getInstance().LOGI("setMessageListener callback what:${what}, arg1:${arg1},arg2:${arg2},obj:${id}")
            let that: IjkMediaPlayer = GlobalListener.map[id]
            let onVideoSizeChangedListener = that.mOnVideoSizeChangedListener
            let onPreparedListener = that.mOnPreparedListener
            let onCompletionListener = that.mOnCompletionListener
            let onBufferingUpdateListener = that.mOnBufferingUpdateListener
            let onErrorListener = that.mOnErrorListener
            let onInfoListener = that.mOnInfoListener
            let onSeekCompleteListener = that.mOnSeekCompleteListener
            let onTimedTextListener = that.mOnTimedTextListener
            if (what == MessageType.MEDIA_PREPARED) {
                if (let Some(v) <- onPreparedListener) {
                    v()
                }
            }
            if (what == MessageType.MEDIA_SET_VIDEO_SAR) {
                that.mVideoSarNum = arg1
                that.mVideoSarDen = arg2
            }
            if (what == MessageType.MEDIA_SET_VIDEO_SIZE) {
                if (let Some(v) <- onVideoSizeChangedListener) {
                    v(arg1, arg2, that.mVideoSarNum, that.mVideoSarDen)
                    if (arg1 != 0 && arg2 != 0) {
                        that.mVideoWidth = arg1
                        that.mVideoHeight = arg2
                    }
                }
            }
            if (what == MessageType.MEDIA_PLAYBACK_COMPLETE) {
                if (let Some(v) <- onCompletionListener) {
                    v()
                }
            }
            if (let Some(v) <- onBufferingUpdateListener) {
                if ((what == MessageType.MEDIA_BUFFERING_UPDATE) || (what == MessageType.MEDIA_BUFFERING_UPDATE)) {
                    var bufferPosition = arg1
                    if (bufferPosition < 0) {
                        bufferPosition = 0
                    }
                    var percent: Int32 = 0
                    var duration = cjGetDuration(that.id)
                    if (duration > 0) {
                        percent = bufferPosition * 100 / duration
                    }
                    if (percent >= 100) {
                        percent = 100
                    }
                    v(percent)
                }
            }
            if (what == MessageType.MEDIA_ERROR) {
                if (let Some(v) <- onErrorListener) {
                    v(Int64(arg1), Int64(arg2))
                }
            }
            if (what == MessageType.MEDIA_INFO) {
                if (let Some(v) <- onInfoListener) {
                    v(Int64(arg1), Int64(arg2))
                }
            }
            if (what == MessageType.MEDIA_SEEK_COMPLETE) {
                if (let Some(v) <- onSeekCompleteListener) {
                    v()
                }
            }
            if (what == MessageType.MEDIA_TIMED_TEXT) {
                if (let Some(v) <- onTimedTextListener) {
                     v(obj.toString())
                }
            }
            if (what == MessageType.MEDIA_AUDIO_INTERRUPT) {
                if (let Some(v) <- onCompletionListener) {
                    if (that.callback.isSome()) {
                        let event: InterruptEvent = InterruptEvent(InterruptForceType.GetType(arg1),
                            InterruptHintType.GetType(arg2))
                        that.callback?.callback(event)
                    }
                }
            }
        }

/** 
 * Open log
 *
 * params xcomponentId - Component ID value
 * return Unit
 */
func cjNativeOpenlog(xcomponentId: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        ijk_nativeOpenlog(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
    }
}

/**
 * Set video source
 *
 * params xcomponentId - Component ID value
 * params url - Video address
 * return Unit
 */
func cjSetDataSource(xcomponentId: String, url: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let path: CString = LibC.mallocCString(url)
        ijk_setDataSource(handle.pointer, Int32(arr.size), path)
        LibC.free(path)
        releaseArrayRawData(handle)
    }
}

/**
 * Set video playback parameters
 *
 * params xcomponentId - Component ID value
 * params category - OPT_CATEGORY_FORMAT、OPT_CATEGORY_CODEC、OPT_CATEGORY_SWS、OPT_CATEGORY_PLAYER
 * params name - parameter,See example
 * params value - See example
 * return Unit
 */
func cjSetOption(xcomponentId: String, category: String, name: String, value: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let ccategory: CString = LibC.mallocCString(category)
        let cname: CString = LibC.mallocCString(name)
        let cvalue: CString = LibC.mallocCString(value)
        ijk_setOption(handle.pointer, Int32(arr.size), ccategory, cname, cvalue)
        LibC.free(ccategory)
        LibC.free(cname)
        LibC.free(cvalue)
        releaseArrayRawData(handle)
    }
}

/**
 * Set video playback parameters
 *
 * params xcomponentId - Component ID value
 * params category - OPT_CATEGORY_FORMAT、OPT_CATEGORY_CODEC、OPT_CATEGORY_SWS、OPT_CATEGORY_PLAYER
 * params name - parameter,See example
 * params value - See example
 * return Unit
 */
func cjSetOptionLong(xcomponentId: String, category: String, name: String, value: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let ccategory: CString = LibC.mallocCString(category)
        let cname: CString = LibC.mallocCString(name)
        let cvalue: CString = LibC.mallocCString(value)
        ijk_setOptionLong(handle.pointer, Int32(arr.size), ccategory, cname, cvalue)
        LibC.free(ccategory)
        LibC.free(cname)
        LibC.free(cvalue)
        releaseArrayRawData(handle)
    }
}

/**
 * Prepare to play
 *
 * params xcomponentId - Component ID value
 * return Unit
 */
func cjPrepareAsync(xcomponentId: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        ijk_prepareAsync(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
    }
}

/**
 * Start playing
 *
 * params xcomponentId - Component ID value
 * return Unit
 */
func cjStart(xcomponentId: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        ijk_start(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
    }
}

/**
 * Stop playing
 *
 * params xcomponentId - Component ID value
 * return Unit
 */
func cjStop(xcomponentId: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        ijk_stop(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
    }
}

/**
 * Pause playing
 *
 * params xcomponentId - Component ID value
 * return Unit
 */
func cjPause(xcomponentId: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        ijk_pause(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
    }
}

/**
 * Reset playing
 *
 * params xcomponentId - Component ID value
 * return Unit
 */
func cjReset(xcomponentId: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        ijk_reset(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
    }
}

/**
 * Release
 *
 * params xcomponentId - Component ID value
 * return Unit
 */
func cjRelease(xcomponentId: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        ijk_release(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
    }
}

/**
 * Fast forward and backward
 *
 * params xcomponentId - Component ID value
 * params msec - "(0 - getDuration)"
 * return Unit
 */
func cjSeekTo(xcomponentId: String, msec: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let cmsec: CString = LibC.mallocCString(msec)
        ijk_seekTo(handle.pointer, Int32(arr.size), cmsec)
        LibC.free(cmsec)
        releaseArrayRawData(handle)
    }
}

/**
 * Determine if it is in playback status
 *
 * params xcomponentId - Component ID value
 * return Bool - true/false
 */
func cjIsPlaying(xcomponentId: String): Bool {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let ret: Bool = ijk_isPlaying(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
        return ret
    }
}

/**
 * Obtain the total duration of the video
 *
 * params xcomponentId - Component ID value
 * return Int32
 */
func cjGetDuration(xcomponentId: String): Int32 {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let ret: Int32 = ijk_getDuration(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
        return ret
    }
}

/**
 * Get the current location for video playback
 *
 * params xcomponentId - Component ID value
 * return Int32
 */
func cjGetCurrentPosition(xcomponentId: String): Int32 {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let ret: Int32 = ijk_getCurrentPosition(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
        return ret
    }
}

/**
 * Get audio session ID
 *
 * params xcomponentId - Component ID value
 * return Int32
 */
func cjGetAudioSessionId(xcomponentId: String): Int32 {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let ret: Int32 = ijk_getAudioSessionId(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
        return ret
    }
}

/**
 * Set video properties
 *
 * params xcomponentId - Component ID value
 * params ids - attribute
 * params value - Attribute value
 * return Unit
 */
func cjSetPropertyFloat(xcomponentId: String, ids: String, value: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let cids: CString = LibC.mallocCString(ids)
        let cvalue: CString = LibC.mallocCString(value)
        ijk_setPropertyFloat(handle.pointer, Int32(arr.size), cids, cvalue)
        releaseArrayRawData(handle)
        LibC.free(cids)
        LibC.free(cvalue)
    }
}

/**
 * Get video properties
 *
 * params xcomponentId - Component ID value
 * params ids - attribute
 * params defaultValue - Default attribute values
 * return Float32
 */
func cjGetPropertyFloat(xcomponentId: String, ids: String, defaultValue: String): Float32 {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let cids: CString = LibC.mallocCString(ids)
        let cvalue: CString = LibC.mallocCString(defaultValue)
        let ret: Float32 = ijk_getPropertyFloat(handle.pointer, Int32(arr.size), cids, cvalue)
        releaseArrayRawData(handle)
        LibC.free(cids)
        LibC.free(cvalue)
        return ret
    }
}

/**
 * Set video properties
 *
 * params xcomponentId - Component ID value
 * params property - attribute
 * params value - Attribute value
 * return Unit
 */
func cjSetPropertyLong(xcomponentId: String, property: String, value: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let cproperty: CString = LibC.mallocCString(property)
        let cvalue: CString = LibC.mallocCString(value)
        ijk_setPropertyLong(handle.pointer, Int32(arr.size), cproperty, cvalue)
        releaseArrayRawData(handle)
        LibC.free(cproperty)
        LibC.free(cvalue)
    }
}

/**
 * Get video properties
 *
 * params xcomponentId - Component ID value
 * params property - attribute
 * params value - Default attribute values
 * return Int64
 */
func cjGetPropertyLong(xcomponentId: String, property: String, value: String): Int64 {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let cproperty: CString = LibC.mallocCString(property)
        let cvalue: CString = LibC.mallocCString(value)
        let ret: Int64 = ijk_getPropertyLong(handle.pointer, Int32(arr.size), cproperty, cvalue)
        releaseArrayRawData(handle)
        LibC.free(cproperty)
        LibC.free(cvalue)
        return ret
    }
}

/**
 * Set up sound channels
 *
 * params xcomponentId - Component ID value
 * params leftVolume - Left vocal tract
 * params rightVolume - Right vocal tract
 * return Unit
 */
func cjSetVolume(xcomponentId: String, leftVolume: String, rightVolume: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let left: CString = LibC.mallocCString(leftVolume)
        let right: CString = LibC.mallocCString(rightVolume)
        ijk_setVolume(handle.pointer, Int32(arr.size), left, right)
        releaseArrayRawData(handle)
        LibC.free(left)
        LibC.free(right)
    }
}

/**
 * Set video loop
 *
 * params xcomponentId - Component ID value
 * params loopCount - Number of cycles
 * return Unit
 */
func cjSetLoopCount(xcomponentId: String, loopCount: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let count: CString = LibC.mallocCString(loopCount)
        ijk_setLoopCount(handle.pointer, Int32(arr.size), count)
        releaseArrayRawData(handle)
        LibC.free(count)
    }
}

/**
 * Get video loop count
 *
 * params xcomponentId - Component ID value
 * return Int32
 */
func cjGetLoopCount(xcomponentId: String): Int32 {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let ret: Int32 = ijk_getLoopCount(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
        return ret
    }
}

/**
 * Select media stream
 *
 * params xcomponentId - Component ID value
 * params stream - 0 - video
 *                 1 - audio
 *                 3 - subtitle
 * params select - "true" or "false"
 * return Int32
 */
func cjSetStreamSelected(xcomponentId: String, stream: String, select: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let cstream: CString = LibC.mallocCString(stream)
        let cselect: CString = LibC.mallocCString(select)
        ijk_setStreamSelected(handle.pointer, Int32(arr.size), cstream, cselect)
        releaseArrayRawData(handle)
        LibC.free(cstream)
        LibC.free(cselect)
    }
}

/**
 * Obtain video decoding
 *
 * params xcomponentId - Component ID value
 * return String
 */
func cjGetVideoCodecInfo(xcomponentId: String): String {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let retC: CString = ijk_getVideoCodecInfo(handle.pointer, Int32(arr.size))
        let ret = retC.toString()
        releaseArrayRawData(handle)
        LibC.free(retC)
        return ret
    }
}

/**
 * Obtain audio decoding
 *
 * params xcomponentId - Component ID value
 * return String
 */
func cjGetAudioCodecInfo(xcomponentId: String): String {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let retC: CString = ijk_getAudioCodecInfo(handle.pointer, Int32(arr.size))
        let ret = retC.toString()
        releaseArrayRawData(handle)
        LibC.free(retC)
        return ret
    }
}

/**
 * Obtaining media information
 *
 * params xcomponentId - Component ID value
 * return String
 */
func cjGetMediaMeta(xcomponentId: String): String {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        let retC: CString = ijk_getMediaMeta(handle.pointer, Int32(arr.size))
        let ret = retC.toString()
        return ret
    }
}

/**
 * initial configuration
 *
 * params xcomponentId - Component ID value
 * return Unit
 */
func cjNativeSetup(xcomponentId: String): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        ijk_native_setup(handle.pointer, Int32(arr.size))
        releaseArrayRawData(handle)
    }
}

func cjSetMessageListener(xcomponentId: String, ijkplayerId: Int32,
    ptr: CFunc<(Int32, Int32, Int32, CString, Int32) -> Unit>): Unit {
    unsafe {
        let arr = xcomponentId.rawData()
        let handle = acquireArrayRawData(arr)
        ijk_setMessageListener(handle.pointer, Int32(arr.size), ijkplayerId, ptr)
        releaseArrayRawData(handle)
    }
}
