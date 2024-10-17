/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public interface CacheListener {
    func onCacheAvailable(cacheFilePath: String, url: String, percentsAvailable: Int64): Unit
}
