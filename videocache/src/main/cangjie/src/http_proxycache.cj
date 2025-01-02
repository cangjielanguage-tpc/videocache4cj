/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class HttpProxyCache <: ProxyCache {
    private var NO_CACHE_BARRIER: Float64 = 0.2
    private var listener: ?CacheListener = None
    var receiveSize: Int64 = 0
    private var offset: Int64 = 0
    private var serverConnect: ?TcpSocket = None

    init(source: HttpUrlSource, cache: FileCache) {
        super(source, cache)
        this.receiveSize = 0
    }

    public override func shutdown(): Unit {
        try {
            this.stopped = true
            super.shutdown()
            if (let Some(i) <- this.serverConnect) {
                i.close()
            }
        } catch (e: Exception) {
        }
        return
    }

    public func registerCacheListener(cacheListener: ?CacheListener): Unit {
        this.listener = cacheListener
    }

    public func processRequest(request: GetRequest, serverConnect: TcpSocket): Unit {
        if (let Some(i) <- this.serverConnect) {
            if (i != serverConnect) {
                i.close()
                this.serverConnect = serverConnect
            }
        }
        let responseHeaders = this.newResponseHeaders(request)
        serverConnect.write(responseHeaders.toArray())
        this.offset = request.rangeOffset
        this.stopped = false
        if (let Some(i) <- this.cache) {
            if (let Some(j) <- this.source) {
                let available = i.available()
                let length = j.length()
                if (length > 0) {
                    let percent = Float64(Float64(available) * 100.0 / Float64(length))
                    this.onCachePercentsAvailableChanged(Int64(percent))
                }
            }
        }
        if (this.isUseCache(request)) {
            this.responseWithCache(this.offset, serverConnect)
        } else {
            this.responseWithoutCache(this.offset, serverConnect)
        }
        return
    }

    //仔细调试
    private func responseWithCache(offset: Int64, serverConnect: TcpSocket): Unit {
        let buff = Array<UInt8>(ProxyCacheUtils.DEFAULT_BUFFER_SIZE, {i: Int64 => return 0})
        var tempoffset = offset
        while (true) {
            let readBytes = this.read(buff, tempoffset, ProxyCacheUtils.DEFAULT_BUFFER_SIZE)
            if (readBytes <= 0) {
                break
            }
            try {
                let trueBuff = buff.slice(0, readBytes)
                if (this.stopped) {
                    break
                }
                serverConnect.write(trueBuff)
            } catch (e: Exception) {
                break
            }
            tempoffset += readBytes
        }
        return
    }

    private func responseWithoutCache(offset: Int64, serverConnect: TcpSocket): Unit {
        let sourceTemp = this.source.getOrThrow {=> NoneValueException("source is null")}
        if (let Some(j) <- sourceTemp as HttpUrlSource) {
            let newSourceNoCache = HttpUrlSource(j)
            try {
                newSourceNoCache.setDataListener(TempDataBackListener(j, this, offset, serverConnect))
                newSourceNoCache.open(offset)
            } catch (e: Exception) {
                newSourceNoCache.close()
                throw e
            }
        }
    }

    private func isUseCache(request: GetRequest): Bool {
        let sourceTemp = this.source.getOrThrow {=> NoneValueException("source is null")}
        let cacheTemp = this.cache.getOrThrow {=> NoneValueException("cache is null")}
        let sourceLength = sourceTemp.length()
        let sourceLengthKnown = sourceLength > 0
        let cacheAvailable = cacheTemp.available()
        let result = !sourceLengthKnown || !request.partial || Float64(request.rangeOffset) <= Float64(cacheAvailable) +
            Float64(sourceLength) * this.NO_CACHE_BARRIER
        return result
    }

    private func newResponseHeaders(request: GetRequest): String {
        let sourceTemp = this.source.getOrThrow {=> NoneValueException("source is null")}
        let cacheTemp = this.cache.getOrThrow {=> NoneValueException("cache is null")}
        var mime = ""
        if (let Some(i) <- sourceTemp as HttpUrlSource) {
            mime = i.getMime()
        }
        var mimeKnown = false
        if (mime.size > 0) {
            mimeKnown = true
        }
        var length: Int64 = 0
        if (cacheTemp.isCompleted()) {
            length = cacheTemp.available()
        } else {
            length = sourceTemp.length()
        }
        let lengthKnown = length >= 0
        var contentLength: Int64 = 0
        if (request.partial) {
            contentLength = length - request.rangeOffset
        } else {
            contentLength = length
        }
        let addRange = lengthKnown && request.partial
        var lengthStr: String = ""
        if (lengthKnown) {
            lengthStr = "Content-Length: ${contentLength}${"\n"} "
        } else {
            lengthStr = ""
        }
        var rangeStr: String = ""
        if (addRange) {
            rangeStr = "Content-Range: bytes ${request.rangeOffset}-${length - 1}/${length}${"\n"}"
        } else {
            rangeStr = ""
        }
        var mimeStr: String = ""
        if (mimeKnown) {
            mimeStr = "Content-Type: ${mime}${"\n"}"
        } else {
            mimeStr = ""
        }
        let str1 = "HTTP/1.1 206 PARTIAL CONTENT${"\n"}${"Accept-Ranges: bytes\n"}${lengthStr}${rangeStr}${mimeStr}${"\n"}"
        let str2 = "HTTP/1.1 200 OK${"\n"}${"Accept-Ranges: bytes\n"}${lengthStr}${rangeStr}${mimeStr}${"\n"}"

        if (request.partial) {
            return str1
        } else {
            return str2
        }
    }

    protected override func onCachePercentsAvailableChanged(percents: Int64): Unit {
        match ((this.listener, this.cache, this.source)) {
            case (Some(listener), Some(cache: FileCache), Some(source: HttpUrlSource)) => listener.onCacheAvailable(
                cache.trueFilePath, source.getUrl(), percents)
            case _ => ()
        }
    }
}
