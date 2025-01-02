/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class StorageUtils {
    private static let INDIVIDUAL_DIR_NAME: String = "video-cache"
    public static let DEFAULT_DIR: String = '/data/storage/el2/base/haps/entry/cache'

    public static func getIndividualCacheDirectory(): String {
        let cacheDir = StorageUtils.getCacheDirectory()
        return cacheDir.getOrThrow() + '/' + StorageUtils.INDIVIDUAL_DIR_NAME
    }

    private static func getCacheDirectory(): ?String {
        return StorageUtils.DEFAULT_DIR
    }
}
