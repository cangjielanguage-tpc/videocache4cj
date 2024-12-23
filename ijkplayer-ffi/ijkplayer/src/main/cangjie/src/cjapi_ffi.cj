/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ijkplayer4cj

/*
 * Cangjie calls the c interface of ijkplayer
 */
foreign {
    func ijk_nativeOpenlog(xcomponentId: CPointer<UInt8>, size: Int32): Unit

    func ijk_setDataSource(xcomponentId: CPointer<UInt8>, size: Int32, url: CString): Unit

    func ijk_setOption(xcomponentId: CPointer<UInt8>, size: Int32, category: CString, name: CString, value: CString): Unit

    func ijk_setOptionLong(xcomponentId: CPointer<UInt8>, size: Int32, category: CString, name: CString, value: CString): Unit

    func ijk_prepareAsync(xcomponentId: CPointer<UInt8>, size: Int32): Unit

    func ijk_start(xcomponentId: CPointer<UInt8>, size: Int32): Unit

    func ijk_stop(xcomponentId: CPointer<UInt8>, size: Int32): Unit

    func ijk_pause(xcomponentId: CPointer<UInt8>, size: Int32): Unit

    func ijk_reset(xcomponentId: CPointer<UInt8>, size: Int32): Unit

    func ijk_release(xcomponentId: CPointer<UInt8>, size: Int32): Unit

    func ijk_seekTo(xcomponentId: CPointer<UInt8>, size: Int32, msec: CString): Unit

    func ijk_isPlaying(xcomponentId: CPointer<UInt8>, size: Int32): Bool

    func ijk_getDuration(xcomponentId: CPointer<UInt8>, size: Int32): Int32

    func ijk_getCurrentPosition(xcomponentId: CPointer<UInt8>, size: Int32): Int32

    func ijk_getAudioSessionId(xcomponentId: CPointer<UInt8>, size: Int32): Int32

    func ijk_setPropertyFloat(xcomponentId: CPointer<UInt8>, size: Int32, ids: CString, value: CString): Unit

    func ijk_getPropertyFloat(xcomponentId: CPointer<UInt8>, size: Int32, ids: CString, default_value: CString): Float32

    func ijk_setPropertyLong(xcomponentId: CPointer<UInt8>, size: Int32, property: CString, value: CString): Unit

    func ijk_getPropertyLong(xcomponentId: CPointer<UInt8>, size: Int32, property: CString, value: CString): Int64

    func ijk_setVolume(xcomponentId: CPointer<UInt8>, size: Int32, leftVolume: CString, rightVolume: CString): Unit

    func ijk_setLoopCount(xcomponentId: CPointer<UInt8>, size: Int32, loopCount: CString): Unit

    func ijk_getLoopCount(xcomponentId: CPointer<UInt8>, size: Int32): Int32

    func ijk_setStreamSelected(xcomponentId: CPointer<UInt8>, size: Int32, stream: CString, select: CString): Unit

    func ijk_getVideoCodecInfo(xcomponentId: CPointer<UInt8>, size: Int32): CString

    func ijk_getAudioCodecInfo(xcomponentId: CPointer<UInt8>, size: Int32): CString

    func ijk_getMediaMeta(xcomponentId: CPointer<UInt8>, size: Int32): CString

    func ijk_native_setup(xcomponentId: CPointer<UInt8>, size: Int32): Unit

    func ijk_setMessageListener(xcomponentId: CPointer<UInt8>, size: Int32, id: Int32,
        ptr: CFunc<(Int32, Int32, Int32, CString, Int32) -> Unit>): Unit
}
