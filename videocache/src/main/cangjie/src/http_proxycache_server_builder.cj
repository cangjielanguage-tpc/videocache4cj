/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class HttpProxyCacheServerBuilder {
    private let DEFAULT_MAX_SIZE: Int64 = 512 * 1024 * 1024
    private var cacheRoot: String = ""
    private var fileNameGenerator: ?FileNameGenerator = None
    private var diskUsage: ?DiskUsage = None
    private var sourceInfoStorage: ?SourceInfoStorage = None
    private var headerInjector: ?HeaderInjector = None
    private var context: AbilityContext

    public init(context: AbilityContext) {
        this.context = context
    }

    /**
     * Overrides default cache folder to be used for caching files.
     * <p>
     * By default AndroidVideoCache uses
     * '/Android/data/[app_package_name]/cache/video-cache/' if card is mounted and app has appropriate permission
     * or 'video-cache' subdirectory in default application's cache directory otherwise.
     * </p>
     * <b>Note</b> directory must be used <b>only</b> for AndroidVideoCache files.
     *
     * @param file a cache directory, can't be null.
     * @return a builder.
     */
    public func cacheDirectory(file: String): HttpProxyCacheServerBuilder {
        this.cacheRoot = file
        return this
    }

    /**
     * Overrides default cache file name generator {@link Md5FileNameGenerator} .
     *
     * @param fileNameGenerator a new file name generator.
     * @return a builder.
     */
    public func setFileNameGenerator(fileNameGenerator: FileNameGenerator): HttpProxyCacheServerBuilder {
        this.fileNameGenerator = fileNameGenerator
        return this
    }

    /**
     * Sets max cache size in bytes.
     * <p>
     * All files that exceeds limit will be deleted using LRU strategy.
     * Default value is 512 Mb.
     * </p>
     * Note this method overrides result of calling {@link #maxCacheFilesCount(int)}
     *
     * @param maxSize max cache size in bytes.
     * @return a builder.
     */
    public func maxCacheSize(maxSize: Int64): HttpProxyCacheServerBuilder {
        this.diskUsage = TotalSizeLruDiskUsage(maxSize)
        return this
    }

    /**
     * Sets max cache files count.
     * All files that exceeds limit will be deleted using LRU strategy.
     * Note this method overrides result of calling {@link #maxCacheSize(long)}
     *
     * @param count max cache files count.
     * @return a builder.
     */
    public func maxCacheFilesCount(count: Int64): HttpProxyCacheServerBuilder {
        this.diskUsage = TotalCountLruDiskUsage(count)
        return this
    }

    /**
     * Set custom DiskUsage logic for handling when to keep or clean cache.
     *
     * @param diskUsage a disk usage strategy, can't be {@code null}.
     * @return a builder.
     */
    public func setDiskUsage(diskUsage: DiskUsage): HttpProxyCacheServerBuilder {
        this.diskUsage = diskUsage
        return this
    }

    /**
     * Add headers along the request to the server
     *
     * @param headerInjector to inject header base on url
     * @return a builder
     */
    public func setHeaderInjector(headerInjector: HeaderInjector): HttpProxyCacheServerBuilder {
        this.headerInjector = headerInjector
        return this
    }

    /**
     * Builds new instance of {@link HttpProxyCacheServer}.
     *
     * @return proxy cache. Only single instance should be used across whole app.
     */
    public func build(): HttpProxyCacheServer {
        // 之所以把初始化从构造函数改到build是因为再构造函数里面初始化之后再在设置setDiskUsage方法里面设置，diskUsage这些对象不会被消除，还能存在，在LruDiskUsage调用accept方法的时候返回结果导致结果异常
        if (this.sourceInfoStorage.isNone()) {
            this.sourceInfoStorage = SourceInfoStorageFactory.newSourceInfoStorage(this.context)
        }
        if (this.cacheRoot.size < 1) {
            this.cacheRoot = StorageUtils.getIndividualCacheDirectory(this.context)
        }
        if (this.diskUsage.isNone()) {
            this.diskUsage = TotalSizeLruDiskUsage(this.DEFAULT_MAX_SIZE)
        }
        if (this.fileNameGenerator.isNone()) {
            this.fileNameGenerator = Md5FileNameGenerator()
        }
        if (this.headerInjector.isNone()) {
            this.headerInjector = EmptyHeadersInjector()
        }
        let config = this.buildConfig()
        return HttpProxyCacheServer(config)
    }

    func buildConfig(): Config {
        return Config(this.cacheRoot, this.fileNameGenerator.getOrThrow(), this.diskUsage.getOrThrow(),
            this.sourceInfoStorage.getOrThrow(), this.headerInjector.getOrThrow())
    }
}
