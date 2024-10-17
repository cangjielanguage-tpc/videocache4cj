/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class UnlimitedDiskUsage <: DiskUsage {
    public func touch(file: String): Unit {
        // do nothing
    }
}
