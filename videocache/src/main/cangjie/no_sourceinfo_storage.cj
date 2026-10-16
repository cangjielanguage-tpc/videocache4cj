/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

public class NoSourceInfoStorage <: SourceInfoStorage {
    public override func release(): Unit {
    }

    public override func put(_: String, _: SourceInfo): Unit {
    }

    public override func get(_: String): ?SourceInfo {
        return Option<SourceInfo>.None
    }
}
