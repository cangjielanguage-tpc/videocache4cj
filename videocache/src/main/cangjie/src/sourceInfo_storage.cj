/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public interface SourceInfoStorage {
    func get(url: String): ?SourceInfo

    func put(url: String, sourceInfo: SourceInfo): Unit

    func release(): Unit
}
