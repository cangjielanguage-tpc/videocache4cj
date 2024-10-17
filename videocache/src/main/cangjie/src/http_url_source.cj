/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class HttpUrlSource <: Source {
    private let MAX_REDIRECTS: Int64 = 5
    private var sourceInfoStorage: ?SourceInfoStorage = None
    private var headerInjector: ?HeaderInjector = None
    private var sourceInfo: ?SourceInfo = None
    private var connection: ?HttpRequest = None
    private var callBack: ?DataBackListener = None
    private var isInitFinish: Bool = false
    private var isHeaderDealFinish: Bool = false
    private var isDataFinish: Bool = false
    private var cacheData: NonBlockingQueue<ByteArrayStream> = NonBlockingQueue<ByteArrayStream>()
    private var timer: ?Timer = None

    init(args: String) {
        if (args.size < 1) {
            throw NoneValueException("params can not be null")
        }
        try {
            this.isInitFinish = false
            this.sourceInfoStorage = SourceInfoStorageFactory.newEmptySourceInfoStorage()
            this.headerInjector = EmptyHeadersInjector()
            var sourceInfo = sourceInfoStorage.getOrThrow().get(args)
            try {
                if (sourceInfo.isSome()) {
                    this.sourceInfo = sourceInfo
                } else {
                    this.sourceInfo = SourceInfo(args, Int64.Min, ProxyCacheUtils.getSupposablyMime(args))
                }
                this.isInitFinish = true
                this.notifyInitFinish()
            } catch (e: Exception) {
                this.sourceInfo = SourceInfo(args, Int64.Min, ProxyCacheUtils.getSupposablyMime(args))
                this.isInitFinish = true
                this.notifyInitFinish()
            }
        } catch (e: Exception) {
            this.isInitFinish = true
            this.notifyInitFinish()
        }

        timer = Timer.repeat(
            Duration.millisecond * 20,
            Duration.millisecond * 20,
            {
                => if (let Some(i) <- this.callBack) {
                    if (!this.isHeaderDealFinish) {
                        return
                    }
                    if (this.sourceInfo.getOrThrow().url.indexOf("ping").isSome()) {
                        return
                    }
                    if (this.cacheData.size > 0) {
                        i.onDataReceive(this.cacheData.dequeue().getOrThrow())
                    } else {
                        if (this.isDataFinish) {
                            this.isHeaderDealFinish = false
                            i.onDataEnd()
                        }
                    }
                } else {
                    return
                }
            }
        )
    }

    init(args: HttpUrlSource) {
        try {
            this.isInitFinish = false
            this.sourceInfo = args.sourceInfo
            this.sourceInfoStorage = args.sourceInfoStorage
            this.headerInjector = args.headerInjector
            this.isInitFinish = true
            this.notifyInitFinish()
        } catch (e: Exception) {
            this.isInitFinish = true
            this.notifyInitFinish()
        }
        timer = Timer.repeat(
            Duration.millisecond * 20,
            Duration.millisecond * 20,
            {
                => if (let Some(i) <- this.callBack) {
                    if (!this.isHeaderDealFinish) {
                        return
                    }
                    if (this.sourceInfo.getOrThrow().url.indexOf("ping").isSome()) {
                        return
                    }
                    if (this.cacheData.size > 0) {
                        i.onDataReceive(this.cacheData.dequeue().getOrThrow())
                    } else {
                        if (this.isDataFinish) {
                            this.isHeaderDealFinish = false
                            i.onDataEnd()
                        }
                    }
                } else {
                    return
                }
            }
        )
    }

    init(url: String, sourceInfoStorage: SourceInfoStorage, headerInjector: HeaderInjector) {
        try {
            this.isInitFinish = false

            this.sourceInfoStorage = sourceInfoStorage
            this.headerInjector = headerInjector
            let sourceInfo = sourceInfoStorage.get(url)
            try {
                if (sourceInfo.isSome()) {
                    this.sourceInfo = sourceInfo
                } else {
                    this.sourceInfo = SourceInfo(url, Int64.Min, ProxyCacheUtils.getSupposablyMime(url))
                }
                this.isInitFinish = true
                this.notifyInitFinish()
            } catch (e: Exception) {
                this.sourceInfo = SourceInfo(url, Int64.Min, ProxyCacheUtils.getSupposablyMime(url))
                this.isInitFinish = true
                this.notifyInitFinish()
            }
        } catch (e: Exception) {
            this.isInitFinish = true
            this.notifyInitFinish()
        }

        timer = Timer.repeat(
            Duration.millisecond * 20,
            Duration.millisecond * 20,
            {
                => if (let Some(i) <- this.callBack) {
                    if (!this.isHeaderDealFinish) {
                        return
                    }
                    if (this.sourceInfo.getOrThrow().url.indexOf("ping").isSome()) {
                        return
                    }
                    if (this.cacheData.size > 0) {
                        i.onDataReceive(this.cacheData.dequeue().getOrThrow())
                    } else {
                        if (this.isDataFinish) {
                            this.isHeaderDealFinish = false
                            i.onDataEnd()
                        }
                    }
                } else {
                    return
                }
            }
        )
    }

    func notifyInitFinish(): Unit {
        let event: InnerEvent = InnerEvent(VideoCacheConstant.HTTP_URL_SOURCE_READY_ID,
            priority: EventPriority.IMMEDIATE)
        Emitter.emit(event)
    }

    public override func close(): Unit {
        try {
            this.cacheData = NonBlockingQueue<ByteArrayStream>()
            if (let Some(i) <- timer) {
                i.cancel()
            }
            Emitter.off(VideoCacheConstant.HTTP_URL_SOURCE_READY_ID)
            this.isHeaderDealFinish = false
            if (let Some(i) <- this.connection) {
                i.offHeadersReceive()
                i.offDataReceive()
                i.offDataReceiveProgress()
                i.offDataEnd()
                i.destroy()
            }
        } catch (e: Exception) {
            throw ProxyCacheException(e.message)
        }
    }

    public func setDataListener(listener: DataBackListener) {
        this.callBack = listener
    }

    public override func length(): Int64 {
        this.checkInit()
        if (let Some(i) <- this.sourceInfo) {
            if (i.length == Int64.Min) {
                this.fetchContentInfo()
            }
            return i.length
        } else {
            return 0
        }
    }

    private func readSourceAvailableBytes(receiveHeader: HashMap<String, String>, offset: Int64): Int64 {
        if (receiveHeader.size < 1) {
            return -1
        }
        let contentLength = this.getContentLength(receiveHeader)
        return contentLength + offset
    }

    private func getContentLength(receiveHeader: HashMap<String, String>): Int64 {
        if (let Some(i) <- receiveHeader as HashMap<String, String>) {
            let result1: Option<String> = i.get("Content-Length")
            if (let Some(j) <- result1) {
                return Int64.parse(j)
            }
            let result2: Option<String> = i.get("content-length")
            if (let Some(j) <- result2) {
                return Int64.parse(j)
            }
            return -1
        } else {
            return -1
        }
    }

    public func open(offset: Int64): Unit {
        this.isHeaderDealFinish = false
        this.isDataFinish = false
        this.checkInit()
        try {
            let sourceInfoTemp = this.sourceInfo.getOrThrow {=> NoneValueException("sourceInfo is null")}
            let sourceInfoStorageTemp = this.sourceInfoStorage.getOrThrow {
                => NoneValueException("sourceInfoStorage is null")
            }
            var mime: String = ""
            let syncCount = SyncCounter(1)
            this.connection = openConnection()
            let connectionTemp = this.connection.getOrThrow {=> NoneValueException("openConnection fail")}
            let callbackTemp = this.callBack.getOrThrow {=> NoneValueException("callBack is null")}
            connectionTemp.onHeadersReceive(
                {
                headers => //
                if (sourceInfoTemp.url.indexOf("ping").isSome()) {
                    callbackTemp.onDataStart()
                } else {
                    if (!headers.isEmpty()) {
                        if (let Some(i) <- headers as HashMap<String, String>) {
                            var mime: String = ""
                            let result1: Option<String> = i.get("content-type")
                            if (let Some(j) <- result1) {
                                mime = j
                            } else {
                                let result2: Option<String> = i.get("Content-Type")
                                if (let Some(k) <- result2) {
                                    mime = k
                                }
                            }
                            let length = this.readSourceAvailableBytes(headers, offset)
                            this.sourceInfo = SourceInfo(sourceInfoTemp.url, length, mime)
                            sourceInfoStorageTemp.put(sourceInfoTemp.url, sourceInfoTemp)
                            callbackTemp.onDataStart()
                        }
                    }
                    this.isHeaderDealFinish = true
                }
            })
            connectionTemp.onDataReceive(
                {
                    data =>
                    if (sourceInfoTemp.url.indexOf("ping").isSome()) {
                        let byteArrayStram = ByteArrayStream()
                        byteArrayStram.write(data)
                        callbackTemp.onDataReceive(byteArrayStram)
                        syncCount.dec()
                    } else {
                        let byteArrayStram = ByteArrayStream()
                        byteArrayStram.write(data)
                        this.cacheData.enqueue(byteArrayStram)
                    }
                    return
                }
            )

            connectionTemp.onDataReceiveProgress({
                progress => this.callBack?.onDataProgress(progress)
            })

            connectionTemp.onDataEnd(
                {
                => if (sourceInfoTemp.url.indexOf("ping").isSome()) {
                    callbackTemp.onDataEnd()
                    syncCount.dec()
                } else {
                    this.isDataFinish = true
                    syncCount.dec()
                }
            })
            let option: HttpRequestOptions = this.initRequestParam(offset, Option<Duration>.None)
            this.cacheData = NonBlockingQueue<ByteArrayStream>()
            connectionTemp.requestInStream(
                sourceInfoTemp.url,
                {
                    err: ?BusinessException, code: ?UInt32 =>
                    if (let Some(e) <- err) {
                        AppLog.error("${e.message}")
                    }
                    if (let Some(respCode) <- code) {
                        AppLog.error("${respCode}")
                    } else {
                        AppLog.error("response is none")
                    }
                },
                options: option
            )
            syncCount.waitUntilZero()
            return
        } catch (e: Exception) {
            this.isHeaderDealFinish = false
            if (let Some(i) <- this.connection) {
                i.destroy()
            }
            throw ProxyCacheException(
                "Error opening connection for " + this.sourceInfo.getOrThrow().url + " with offset " + offset.toString() +
                e.message)
        }
    }

    private func fetchContentInfo(): Unit {
        this.checkInit()
        var urlConnection: ?HttpRequest = None
        try {
            let syncCount = SyncCounter(1)
            urlConnection = this.openConnection()
            let urlConnectionTemp = urlConnection.getOrThrow {=> NoneValueException("openConnection fail")}
            let sourceInfoTemp = this.sourceInfo.getOrThrow {=> NoneValueException("sourceInfo is null")}
            urlConnectionTemp.onceHeadersReceive(
                {
                    headers =>
                    if (!headers.isEmpty()) {
                        let length = this.getContentLength(headers)
                        if (let Some(i) <- headers as HashMap<String, String>) {
                            var mime: String = ""
                            let result1: Option<String> = i.get("content-type")
                            if (let Some(j) <- result1) {
                                mime = j
                            } else {
                                let result2: Option<String> = i.get("Content-Type")
                                if (let Some(k) <- result2) {
                                    mime = k
                                }
                            }
                            this.sourceInfo = SourceInfo(sourceInfoTemp.url, length, mime)
                            this.sourceInfoStorage?.put(sourceInfoTemp.url, sourceInfoTemp)
                            syncCount.dec()
                        }
                    }
                    return
                }
            )
            let option = this.initRequestParam(0, Duration.millisecond * 10000)
            urlConnectionTemp.requestInStream(sourceInfoTemp.url, {e: ?BusinessException, value: ?UInt32 =>},
                options: option)
            syncCount.waitUntilZero(timeout:Duration.second * 6)
            urlConnectionTemp.destroy()
            return
        } catch (e: Exception) {
            throw e
        }
    }

    private func openConnection(): HttpRequest {
        try {
            if (let Some(i) <- this.connection) {
                i.offHeadersReceive()
                i.offDataReceive()
                i.offDataReceiveProgress()
                i.offDataEnd()
                i.destroy()
            }
            this.connection = None
        } catch (e: Exception) {
            this.connection = None
        }
        return createHttp()
    }

    private func initRequestParam(offset: Int64, timeout: ?Duration): HttpRequestOptions {
        var headerHashMap: HashMap<String, String> = HashMap<String, String>()
        headerHashMap.put("Content-Type", "application/json")
        headerHashMap.put("Connection", "Keep-Alive")
        var option: ?HttpRequestOptions = None
        if (let Some(i) <- timeout) {
            option = HttpRequestOptions(method: RequestMethod.GET, header: headerHashMap,
                connectTimeout: UInt32(i.toMilliseconds()), readTimeout: UInt32(i.toMilliseconds()),
                usingProtocol: HttpProtocol.HTTP1_1)
        } else {
            option = HttpRequestOptions(method: RequestMethod.GET, header: headerHashMap, connectTimeout: 10000,
                readTimeout: 0, usingProtocol: HttpProtocol.HTTP1_1)
        }
        var optionNotNull = option.getOrThrow()
        if (let Some(i) <- this.sourceInfo) {
            optionNotNull = this.injectCustomHeaders(optionNotNull, i.url)
            if (let Some(j) <- optionNotNull.header) {
                if (offset > 0) {
                    j.put("Range", "bytes=" + offset.toString() + "-")
                }
                return optionNotNull
            } else {
                return optionNotNull
            }
        } else {
            return optionNotNull
        }
    }

    private func injectCustomHeaders(option: HttpRequestOptions, url: String): HttpRequestOptions {
        if (let Some(i) <- this.headerInjector) {
            let extraHeaders = i.addHeaders(url)
            if (extraHeaders.size < 1) {
                return option
            }
            for (key in extraHeaders.keys()) {
                if (key.size > 0) {
                    let value = extraHeaders.get(key)
                    if (let Some(j) <- value) {
                        if (j.size > 0) {
                            if (let Some(k) <- option.header) {
                                k.put(key, j)
                            }
                        }
                    }
                }
            }
            return option
        } else {
            return option
        }
    }

    public func getMime(): String {
        this.checkInit()
        if (let Some(i) <- this.sourceInfo) {
            if (i.mime.size < 1) {
                this.fetchContentInfo()
            }
        } else {
            this.fetchContentInfo()
        }
        if (let Some(i) <- this.sourceInfo) {
            if (i.mime.size > 0) {
                return i.mime
            }
        }
        throw NoneValueException("can not get sourceInfo.mime")
    }

    private func checkInit(): Unit {
        let syncCount = SyncCounter(1)
        if (!this.isInitFinish) {
            let event: InnerEvent = InnerEvent(VideoCacheConstant.HTTP_URL_SOURCE_READY_ID)
            Emitter.on(
                event,
                EventCallback(
                    "HTTP_URL_SOURCE_READY_ID",
                    {
                        data: EventData => syncCount.dec()
                    }
                )
            )
        } else {
            syncCount.dec()
        }
        syncCount.waitUntilZero(timeout:Duration.second * 6)
    }

    public func getUrl(): String {
        if (let Some(i) <- this.sourceInfo) {
            return i.url
        } else {
            return ""
        }
    }

    public func toString(): String {
        if (let Some(i) <- this.sourceInfo) {
            return "HttpUrlSource{sourceInfo='" + i.toString() + "}"
        }
        return "sourceInfo="
    }
}
