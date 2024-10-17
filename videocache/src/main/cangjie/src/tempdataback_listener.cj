/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class TempDataBackListener <: DataBackListener {
    protected var newSourceNoCache: ?HttpUrlSource = None
    private var httpProxyCache: ?HttpProxyCache = None
    private var offset: Int64 = 0
    private var serverConnect: ?TcpSocket = None

    init(source: HttpUrlSource, httpProxyCache: HttpProxyCache, offset: Int64, serverConnect: TcpSocket) {
        this.newSourceNoCache = source
        this.httpProxyCache = httpProxyCache
        this.offset = offset
        this.serverConnect = serverConnect
    }

    public override func onDataEnd() {
        newSourceNoCache.getOrThrow().close()
        return
    }

    public override func onDataStart() {
        this.httpProxyCache.getOrThrow().receiveSize = offset
    }

    public override func onDataReceive(data: ByteArrayStream) {
        this.httpProxyCache.getOrThrow().receiveSize += data.length
        try {
            serverConnect.getOrThrow().write(data.bytes())
        } catch (e: Exception) {
            throw e
        }
    }

    public override func onDataProgress(progress: DataReceiveProgressInfo) {
    }
}
