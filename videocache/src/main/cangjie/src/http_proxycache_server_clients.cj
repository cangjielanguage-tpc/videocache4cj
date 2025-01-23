/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

public class HttpProxyCacheServerClients {
    private var url: String = ""
    private var proxyCache: ?HttpProxyCache = None
    private var uiCacheListener: ?CacheListener = None
    private var config: ?Config = None
    private var listeners = ArrayList<CacheListener>()
    let mtx = ReentrantMutex()

    init(url: String, config: Config) {
        this.url = url
        this.config = config
        this.uiCacheListener = UiListenerHandler(url, this.listeners)
    }

    func processRequest(request: GetRequest, severConnect: TcpSocket): Unit {
        try {
            this.finishProcessRequest()
            this.startProcessRequest()
            if (let Some(i) <- this.proxyCache) {
                i.processRequest(request, severConnect)
            } else {
                throw NoneValueException("proxyCache is null")
            }
        } catch (e: Exception) {
            throw e
        }
        return
    }

    private func startProcessRequest(): Unit {
        synchronized(mtx) {
            if (this.proxyCache.isNone()) {
                this.proxyCache = newHttpProxyCache()
            }
        }
    }

    private func newHttpProxyCache(): HttpProxyCache {
        let configTemp = this.config.getOrThrow {=> NoneValueException("proxyCache is null")}
        let source = HttpUrlSource(this.url, configTemp.sourceInfoStorage, configTemp.headerInjector)
        //在这里决定了缓存目录
        let cache = FileCache(configTemp.generateCacheFile(this.url), configTemp.diskUsage)
        let httpProxyCache = HttpProxyCache(source, cache)
        httpProxyCache.registerCacheListener(this.uiCacheListener)
        return httpProxyCache
    }

    private func finishProcessRequest(): Unit {
        synchronized(mtx) {
            if (let Some(i) <- this.proxyCache) {
                i.shutdown()
            }
            this.proxyCache = None
            return
        }
    }

    public func registerCacheListener(cacheListener: CacheListener): Unit {
        this.listeners.append(cacheListener)
    }

    public func unregisterCacheListener(cacheListener: CacheListener): Unit {
        this.listeners.removeIf(
            {
            listener: CacheListener => return refEq((listener as Object).getOrThrow(),
                (cacheListener as Object).getOrThrow())
        })
    }

    public func shutdown(): Unit {
        this.listeners.clear()
        if (let Some(i) <- this.proxyCache) {
            i.registerCacheListener(None)
            i.shutdown()
        }
        this.proxyCache = None
        return
    }

    func getClientsCount(): Int64 {
        return 0
    }
}
