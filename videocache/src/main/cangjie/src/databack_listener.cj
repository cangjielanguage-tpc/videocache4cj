/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public interface DataBackListener {
    func onDataReceive(data: ByteArrayStream): Unit

    func onDataProgress(progress: DataReceiveProgressInfo): Unit

    func onDataEnd(): Unit

    func onDataStart(): Unit
}
