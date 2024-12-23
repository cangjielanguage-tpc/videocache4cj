/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public interface Cache {
    func available(): Int64

    func totalLength(): Int64

    func read(buffer: Array<UInt8>, offset: Int64, length: Int64): Int64

    func append(data: Array<UInt8>, length: Int64): Unit

    func close(): Unit

    func complete(): Unit

    func isCompleted(): Bool

    func setFileLength(length: Int64): Unit
}
