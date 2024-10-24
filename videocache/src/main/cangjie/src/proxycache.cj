/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public open class ProxyCache {
    private let MAX_READ_SOURCE_ATTEMPTS: Int64 = 1
    protected var source: ?Source = None
    protected var cache: ?Cache = None
    public var readSourceErrorsCount: Int64 = 0
    protected var stopped: Bool = false
    private var readingInProgress: Bool = false
    private var percentsAvailable: Int64 = -1
    private var timer: ?Timer = None

    init(source: Source, cache: Cache) {
        this.source = source
        this.cache = cache
        this.stopped = false
    }

    public func read(buffer: Array<UInt8>, offset: Int64, length: Int64): Int64 {
        if (let Some(i) <- this.cache) {
            while (!i.isCompleted() && i.available() < (offset + length) && !this.stopped) {
                this.readSourceAsync()
                sleep(Duration.second * 1)
                this.checkReadSourceErrorsCount()
            }
            let read = i.read(buffer, offset, length)
            if (i.isCompleted() && this.percentsAvailable != 100) {
                this.percentsAvailable = 100
                this.onCachePercentsAvailableChanged(100)
            }
            if (this.stopped) {
                return -1
            } else {
                return read
            }
        } else {
            throw NoneValueException('cache is null,can not read any thing')
        }
    }

    private func checkReadSourceErrorsCount(): Unit {
        let errorsCount = this.readSourceErrorsCount
        if (errorsCount >= this.MAX_READ_SOURCE_ATTEMPTS) {
            this.readSourceErrorsCount = 0
            throw ProxyCacheException("Error reading source " + errorsCount.toString() + " times")
        }
    }

    public open func shutdown(): Unit {
        AppLog.debug("Shutdown proxy for this.source")
        try {
            this.stopped = true
            if (let Some(i) <- this.timer) {
                i.cancel()
            }
            this.closeSource()
        } catch (e: Exception) {
            this.onError(e)
        }
        try {
            if (let Some(i) <- this.cache) {
                i.close()
            }
            this.cache = None
        } catch (e: Exception) {
            this.onError(e)
        }
        return
    }

    private func readSourceAsync(): Unit {
        if (!this.stopped && (this.cache.isSome() && !this.cache.getOrThrow().isCompleted()) && !this.readingInProgress) {
            this.readSource()
        }
    }

    private func waitForSourceData(): Unit {
        this.timer = Timer.once(
            Duration.second,
            {
                => if (let Some(i) <- this.timer) {
                    i.cancel()
                    this.timer = None
                    return
                }
            }
        )
    }

    func notifyNewCacheDataAvailable(cacheAvailable: Int64, sourceAvailable: Int64): Unit {
        this.onCacheAvailable(cacheAvailable, sourceAvailable)
    }

    protected func onCacheAvailable(cacheAvailable: Int64, sourceLength: Int64): Unit {
        let zeroLengthSource = sourceLength == 0
        var percents: Int64 = 0
        if (zeroLengthSource) {
            percents = 100
        } else {
            percents = Int64(Float64(cacheAvailable) / Float64(sourceLength) * 100.0)
        }
        let percentsChanged = percents != this.percentsAvailable
        let sourceLengthKnown = sourceLength >= 0
        if (sourceLengthKnown && percentsChanged) {
            this.onCachePercentsAvailableChanged(percents)
        }
        this.percentsAvailable = percents
    }

    protected open func onCachePercentsAvailableChanged(percentsAvailable: Int64): Unit {
    }

    private func readSource(): Unit {
        spawn {
            let cacheTemp = this.cache.getOrThrow {=> NoneValueException("cache is null")}
            let sourceTemp = this.source.getOrThrow {=> NoneValueException("source is null")}

            let sourceAvailable = -1
            var offset = 0
            try {
                offset = cacheTemp.available()
                sourceTemp.setDataListener(MyDataBackListener(this, offset, sourceAvailable))
                this.readingInProgress = true
                sourceTemp.open(offset)
                this.readingInProgress = false
                return
            } catch (e: Exception) {
                this.readingInProgress = false
                this.readSourceErrorsCount++
                this.onError(e)
            }
        }
    }

    func onSourceRead(): Unit {
        // guaranteed notify listeners after source read and cache completed
        this.percentsAvailable = 100
        this.onCachePercentsAvailableChanged(this.percentsAvailable)
    }

    func tryComplete(): Unit {
        let cacheTemp = this.cache.getOrThrow {=> NoneValueException("cache is null")}
        let sourceTemp = this.source.getOrThrow {=> NoneValueException("source is null")}
        this.readingInProgress = false
        if (!this.isStopped() && cacheTemp.available() == sourceTemp.length()) {
            cacheTemp.complete()
        }
        return
    }

    func isStopped(): Bool {
        return this.stopped
    }

    func closeSource(): Unit {
        try {
            if (let Some(i) <- this.source) {
                i.close()
            }
        } catch (e: Exception) {
            this.onError(ProxyCacheException("Error closing source reason is " + e.message))
        }
    }

    protected func setFileLength(length: Int64) {
        if (let Some(i) <- this.cache) {
            i.setFileLength(length)
        }
    }

    protected func onError(e: Exception): Unit {
        let interruption = e as InterruptedProxyCacheException
        this.readingInProgress = false
        if (interruption.isSome()) {
            AppLog.debug("ProxyCache is interrupted")
        } else {
            AppLog.error("ProxyCache error : " + e.message)
        }
    }

    func totalLength(): Int64 {
        if (let Some(i) <- this.cache) {
            return i.totalLength()
        } else {
            return 0
        }
    }
}
