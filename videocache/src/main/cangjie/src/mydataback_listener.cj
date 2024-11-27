/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class MyDataBackListener <: DataBackListener {
    private var proxyCache: ProxyCache
    private var offset: Int64
    private var sourceAvailable: Int64

    init(proxyCache: ProxyCache, offset: Int64, sourceAvailable: Int64) {
        this.proxyCache = proxyCache
        this.offset = offset
        this.sourceAvailable = sourceAvailable
    }

    public override func onDataEnd(): Unit {
        try {
            proxyCache.tryComplete()
            proxyCache.onSourceRead()
        } finally {
            proxyCache.closeSource()
            proxyCache.notifyNewCacheDataAvailable(offset, sourceAvailable)
        }
    }

    public override func onDataStart(): Unit {
        sourceAvailable = proxyCache.source.getOrThrow().length()
        proxyCache.setFileLength(sourceAvailable)
    }

    public override func onDataReceive(data: Array<UInt8>): Unit {
        if (proxyCache.isStopped()) {
            return
        }
        proxyCache.cache.getOrThrow().append(data, data.size)
        offset += data.size
        proxyCache.notifyNewCacheDataAvailable(offset, sourceAvailable)
    }

    public override func onDataProgress(progress: DataReceiveProgressInfo): Unit {
    }
}
