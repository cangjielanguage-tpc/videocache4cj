/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class NoSourceInfoStorage <: SourceInfoStorage {
    public override func release(): Unit {
    }

    public override func put(url: String, sourceInfo: SourceInfo): Unit {
    }

    public override func get(url: String): ?SourceInfo {
        return Option<SourceInfo>.None
    }
}
