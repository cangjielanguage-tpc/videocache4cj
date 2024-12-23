/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class Config {
    public var cacheRoot: String
    public var fileNameGenerator: FileNameGenerator
    public var diskUsage: DiskUsage
    public var sourceInfoStorage: SourceInfoStorage
    public var headerInjector: HeaderInjector

    init(cacheRoot: String, fileNameGenerator: FileNameGenerator, diskUsage: DiskUsage,
        sourceInfoStorage: SourceInfoStorage, headerInjector: HeaderInjector) {
        this.cacheRoot = cacheRoot
        this.fileNameGenerator = fileNameGenerator
        this.diskUsage = diskUsage
        this.sourceInfoStorage = sourceInfoStorage
        this.headerInjector = headerInjector
    }

    func generateCacheFile(url: String): String {
        //这里生成自定义文件名
        let name = this.fileNameGenerator.generate(url)
        return this.cacheRoot + '/' + name
    }
}
