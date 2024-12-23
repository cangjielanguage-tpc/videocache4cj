/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class SourceInfoStorageFactory {
    public static func newSourceInfoStorage(context: StageContext): SourceInfoStorage {
        return DatabaseSourceInfoStorage(context)
    }

    public static func newEmptySourceInfoStorage(): SourceInfoStorage {
        return NoSourceInfoStorage()
    }
}
