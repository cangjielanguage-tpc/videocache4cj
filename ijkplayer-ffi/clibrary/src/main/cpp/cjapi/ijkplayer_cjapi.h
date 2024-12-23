/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

#ifndef ijkplayer_ijkplayer_cjapi_H
#define ijkplayer_ijkplayer_cjapi_H
#include "../napi/ijkplayer_napi.h"
#ifdef __cplusplus
extern "C" {
#endif

void ijk_nativeOpenlog(char *xcomponentId, int size);
void ijk_setDataSource(char *xcomponentId, int size, char *url);
void ijk_setOption(char *xcomponentId, int size, char *category, char *name, char *value);
void ijk_setOptionLong(char *xcomponentId, int size, char *category, char *name, char *value);
void ijk_prepareAsync(char *xcomponentId, int size);
void ijk_start(char *xcomponentId, int size);
void ijk_stop(char *xcomponentId, int size);
void ijk_pause(char *xcomponentId, int size);
void ijk_reset(char *xcomponentId, int size);
void ijk_release(char *xcomponentId, int size);
void ijk_seekTo(char *xcomponentId, int size, char *msec);
bool ijk_isPlaying(char *xcomponentId, int size);
int ijk_getDuration(char *xcomponentId, int size);
int ijk_getCurrentPosition(char *xcomponentId, int size);
int ijk_getAudioSessionId(char *xcomponentId, int size);
void ijk_setPropertyFloat(char *xcomponentId, int size, char *ids, char *value);
float ijk_getPropertyFloat(char *xcomponentId, int size, char *ids, char *default_value);
void ijk_setPropertyLong(char *xcomponentId, int size, char *property, char *value);
long long ijk_getPropertyLong(char *xcomponentId, int size, char *property, char *value);
void ijk_setVolume(char *xcomponentId, int size, char *leftVolume, char *rightVolume);
void ijk_setLoopCount(char *xcomponentId, int size, char *loopCount);
int ijk_getLoopCount(char *xcomponentId, int size);
void ijk_setStreamSelected(char *xcomponentId, int size, char *stream, char *select);
char *ijk_getVideoCodecInfo(char *xcomponentId, int size);
char *ijk_getAudioCodecInfo(char *xcomponentId, int size);
char *ijk_getMediaMeta(char *xcomponentId, int size);
void ijk_native_setup(char *xcomponentId, int size);

// long long ijk_getIjkplayerPtr(char *xcomponentId);
// void ijk_setIjkplayerPtr(char *xcomponentId, char *ids);
// void ijk_setMessagePostEventPtr(char *xcomponentId, char *ids);
void ijk_setMessageListener(char *xcomponentId, int size, int ijkplayer_id,
                            void (*pe)(int what, int arg1, int arg2, char *obj, int ijkplayer_id));

#ifdef __cplusplus
} /* extern "C" */
#endif /* __cplusplus */
#endif /* ijkplayer_ijkplayer_cjapi.h_H */
