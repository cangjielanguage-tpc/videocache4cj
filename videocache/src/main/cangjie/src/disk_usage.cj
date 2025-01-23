/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

public interface DiskUsage {
    func touch(filePath: String): Unit
}
