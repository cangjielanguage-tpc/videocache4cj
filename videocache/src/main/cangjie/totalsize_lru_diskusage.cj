/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

public class TotalSizeLruDiskUsage <: LruDiskUsage {
    var maxSize: Int64 = 0

    init(maxSize: Int64) {
        super()
        if (maxSize <= 0) {
            throw IllegalArgumentException("Max size must be positive number!")
        }
        this.maxSize = maxSize
    }

    public override func accept(_: String, totalSize: Int64, _: Int64): Bool {
        return totalSize <= this.maxSize
    }
}
