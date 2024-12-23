/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

import std.sync.Semaphore

public class HttpProxyCacheServer {
    private static var libraryVersion: String = '1.0.0'
    private let PROXY_HOST: String = "127.0.0.1"
    private var clientsMap: HashMap<String, HttpProxyCacheServerClients> = HashMap<String, HttpProxyCacheServerClients>(
    )
    private var port: UInt16 = 0
    private var config: ?Config = None
    private var pinger: ?Pinger = None
    private var serverSocket: ?TcpServerSocket = None
    private var isServerReady: Bool = false
    let mtx = ReentrantMutex()

    static func setLibraryVersion(version: String) {
        if (version.size >= 1) {
            HttpProxyCacheServer.libraryVersion = version
        } else {
            HttpProxyCacheServer.libraryVersion = '1.0.0'
        }
    }

    static func getLibraryVersion(): String {
        if (HttpProxyCacheServer.libraryVersion.size < 1) {
            HttpProxyCacheServer.libraryVersion = '1.0.0'
        }
        return HttpProxyCacheServer.libraryVersion
    }

    init(param: Config) {
        this.config = param
        try {
            let m: Random = Random()
            this.port = UInt16(round((m.nextFloat64() * (65535.0 - 1024.0)) + 1024.0))
            this.waitForRequest()
        } catch (e: Exception) {
            throw IllegalStateException("Error starting local proxy server " + e.message)
        }
    }

    init(param: StageContext) {
        this.config = HttpProxyCacheServerBuilder(param).buildConfig()
        try {
            let m: Random = Random()
            this.port = UInt16(round((m.nextFloat64() * (65535.0 - 1024.0)) + 1024.0))
            this.waitForRequest()
        } catch (e: Exception) {
            throw IllegalStateException("Error starting local proxy server " + e.message)
        }
    }

    func waitForRequest(): Unit {
        try {
            let requestArg: NetAddress = NetAddress(this.PROXY_HOST, 1, this.port)
            this.serverSocket = TcpServerSocket(bindAt: this.port)
            this.serverSocket.getOrThrow().bind()
            spawn {
                AppLog.error("进thread waitForRequest")
                while (true) {
                    let client: TcpSocket = this.serverSocket.getOrThrow().accept()
                    AppLog.error("进来了1111")
                    var readCount = 0
                    var bufTotal: ArrayList<UInt8> = ArrayList<UInt8>()
                    let buf = Array<UInt8>(4 * 1024, {i: Int64 => return 0})

                    readCount = client.read(buf)
                    if (readCount > 0) {
                        let usefulBuf = buf.slice(0, readCount)
                        bufTotal.appendAll(usefulBuf)
                    }
                    processSocket(bufTotal.toArray(), client)
                    AppLog.error("进来了3333")
                }
            }
            this.pinger = Pinger(this.PROXY_HOST, this.port)
            this.isServerReady = true
            return
        } catch (e: Exception) {
            throw e
        }
    }

    func processSocket(requestInfo: Array<UInt8>, severConnect: TcpSocket) {
        spawn {
            AppLog.error("进thread processSocket")
            try {
                let request = GetRequest.read(requestInfo)
                let url = request.uri
                if (this.pinger.getOrThrow().isPingRequest(url)) {
                    this.pinger.getOrThrow().responseToPing(severConnect)
                } else {
                    AppLog.error("----- HttpProxyCacheServer processSocket not ping")
                    let clients = getClients(url)
                    clients.processRequest(request, severConnect)
                }
            } catch (e: Exception) {
                this.onError(ProxyCacheException("Error processing request,reason is : " + e.message))
            }
        }
    }

    public func getProxyUrl(url: String, allowCachedFileUri: Bool): Future<String> {
        let res: Future<String> = spawn {
            AppLog.error("进thread getProxyUrl")
            if (allowCachedFileUri && this.isCached(url) && !url.endsWith(".m3u8")) {
                let cacheFile = this.getCacheFile(url)
                this.touchFileSafely(cacheFile)
                return cacheFile
            }
            let result = this.isAlive()
            if (result) {
                return this.appendToProxyUrl(url)
            } else {
                return url
            }
        }
        return res
    }

    /**
     * 返回端口号 用于编写单元测试
     * @returns 端口号
     */
    public func getProxyPort(): UInt16 {
        return this.port
    }

    /**
     * 返回代理服务器配置信息 用于编写单元测试
     * @returns 代理服务器配置信息
     */
    public func getConfig(): ?Config {
        return this.config
    }

    /**
     * Checks is cache contains fully cached file for particular url.
     *
     * @param url an url cache file will be checked for.
     * @return {@code true} if cache contains fully cached file for passed in parameters url.
     */
    public func isCached(url: String): Bool {
        if (url.size < 1) {
            throw NoneValueException("Url can't be null!")
        }
        return FileFs.access(this.getCacheFile(url))
    }

    private func appendToProxyUrl(url: String): String {
        return "http://${this.PROXY_HOST}:${this.port}/${url}"
    }

    private func getCacheFile(url: String): String {
        if (let Some(i) <- this.config) {
            let cacheDir = i.cacheRoot
            let fileName = i.fileNameGenerator.generate(url)
            return "${cacheDir}/${fileName}"
        }
        return ""
    }

    private func isAlive(): Bool {
        if (let Some(i) <- this.pinger) {
            let result = i.ping(3, 70) // 70+140+280=max~500ms
            return result
        } else {
            return false
        }
    }

    private func touchFileSafely(cacheFile: String): Unit {
        try {
            if (let Some(i) <- this.config) {
                i.diskUsage.touch(cacheFile)
            }
        } catch (e: Exception) {
            AppLog.error("Error touching file " + cacheFile + "  ,reason is " + e.message)
        }
    }

    public func registerCacheListener(cacheListener: CacheListener, url: String): Unit {
        synchronized(mtx) {
            if (url.size < 1) {
                throw NoneValueException("url is null")
            }
            try {
                this.getClients(url).registerCacheListener(cacheListener)
            } catch (e: Exception) {
                AppLog.warn("Error registering cache listener,reason is : " + e.message)
            }
        }
    }

    public func unregisterCacheListener(cacheListener: CacheListener, url: String): Unit {
        synchronized(mtx) {
            if (url.size > 0) {
                try {
                    this.getClients(url).unregisterCacheListener(cacheListener)
                } catch (e: Exception) {
                    AppLog.warn("Error registering cache listener,reason is : " + e.message)
                }
            } else {
                for ((k, v) in this.clientsMap) {
                    v.unregisterCacheListener(cacheListener)
                }
            }
        }
    }

    public func shutdown(): Unit {
        AppLog.info("Shutdown proxy server")
        let event: InnerEvent = InnerEvent(VideoCacheConstant.SHUT_DOWN_TASKPOOL, priority: EventPriority.IMMEDIATE)
        Emitter.emit(event)
        this.shutdownClients()
        if (let Some(i) <- this.config) {
            i.sourceInfoStorage.release()
        }
        this.serverSocket.getOrThrow().close()
        Emitter.off(VideoCacheConstant.PING_EVENT_ID)
        Emitter.off(VideoCacheConstant.SEND_TOTAL_SIZE_ID)
        Emitter.off(VideoCacheConstant.SEND_ACCEPT_ID)
        Emitter.off(VideoCacheConstant.COUNT_TOTAL_SIZE_ID)
        Emitter.off(VideoCacheConstant.COUNT_TOTAL_SIZE_START_ID)
        Emitter.off(VideoCacheConstant.COUNT_TOTAL_SIZE_END_ID)
        Emitter.off(VideoCacheConstant.GET_ACCEPT_ID)
        Emitter.off(VideoCacheConstant.HTTP_URL_SOURCE_READY_ID)
        Emitter.off(VideoCacheConstant.SERVER_READY_ID)
        Emitter.off(VideoCacheConstant.RENAME_FINISH_ID)
        Emitter.off(VideoCacheConstant.SHUT_DOWN_TASKPOOL)
        this.serverSocket = None
    }

    private func onError(e: ProxyCacheException): Unit {
        AppLog.error("HttpProxyCacheServer error,reason is " + e.message)
    }

    private func onError(e: Exception): Unit {
        AppLog.error("HttpProxyCacheServer error,reason is " + e.message)
    }

    private func shutdownClients(): Unit {
        synchronized(mtx) {
            for ((k, v) in this.clientsMap) {
                v.shutdown()
            }
            this.clientsMap.clear()
        }
    }

    private func getClients(url: String): HttpProxyCacheServerClients {
        synchronized(mtx) {
            let configTemp = this.config.getOrThrow {=> NoneValueException("config is null")}
            if (url.size < 1) {
                throw NoneValueException("url is null")
            }
            var clients = this.clientsMap.get(url)
            if (clients.isNone()) {
                clients = HttpProxyCacheServerClients(url, configTemp)
                this.clientsMap.put(url, clients.getOrThrow())
            }
            return clients.getOrThrow()
        }
    }

    private func getClientsCount(): Int64 {
        synchronized(mtx) {
            var count = 0
            for ((k, v) in this.clientsMap) {
                count += v.getClientsCount()
            }
            return count
        }
    }
}
