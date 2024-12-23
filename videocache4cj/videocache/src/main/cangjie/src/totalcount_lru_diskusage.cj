/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class TotalCountLruDiskUsage <: LruDiskUsage {
    var maxCount: Int64 = 0

    init(maxCount: Int64) {
        super()
        if (maxCount <= 0) {
            throw IllegalArgumentException("Max count must be positive number!")
        }
        this.maxCount = maxCount
    }

    public override func accept(file: String, totalSize: Int64, totalCount: Int64): Bool {
        return totalCount <= this.maxCount
    }
}
