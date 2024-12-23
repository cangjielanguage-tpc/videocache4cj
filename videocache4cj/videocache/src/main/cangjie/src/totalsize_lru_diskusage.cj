/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
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

    public override func accept(file: String, totalSize: Int64, totalCount: Int64): Bool {
        return totalSize <= this.maxSize
    }
}
