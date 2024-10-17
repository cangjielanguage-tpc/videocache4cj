/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public interface DiskUsage {
    func touch(filePath: String): Unit
}
