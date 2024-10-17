/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class UiListenerHandler <: CacheListener {
    var url: String = ""
    private var listeners: ArrayList<CacheListener> = ArrayList<CacheListener>()

    init(url: String, listeners: ArrayList<CacheListener>) {
        this.url = url
        this.listeners = listeners
    }

    public func onCacheAvailable(cacheFilePath: String, url: String, percentsAvailable: Int64) {
        if (this.listeners.size < 1) {
            return
        }
        for (i in 0..this.listeners.size) {
            let listener = this.listeners[i] as CacheListener
            listener.getOrThrow().onCacheAvailable(cacheFilePath, url, percentsAvailable)
        }
    }
}
