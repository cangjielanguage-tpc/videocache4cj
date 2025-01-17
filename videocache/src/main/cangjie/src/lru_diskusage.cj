/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public open class LruDiskUsage <: DiskUsage {
    private var list: ArrayList<String> = ArrayList()
    private var file: String = ""
    private var totalSize: Int64 = 0
    private var totalCount: Int64 = 0

    public open func accept(file: String, totalSize: Int64, totalCount: Int64): Bool {
        return false
    }

    func countTotalSize(files: ArrayList<String>): Int64 {
        var totalSize = 0
        for (i in 0..files.size) {
            let file: String = files[i]
            if (!FileFs.access(file)) {
                continue
            }
            let tempSize = FileFs.stat(file).size
            totalSize += tempSize
        }
        return totalSize
    }

    init() {
        this.list = ArrayList()
    }


    public func touch(filePath: String): Unit {
        if (filePath.size < 1 || !filePath.startsWith(StorageUtils.DEFAULT_DIR)) {
            return
        }
        spawn {
            Files.setLastModifiedNow(filePath)
            let last = filePath.lastIndexOf("/")
            let directory: String = filePath[0..last.getOrThrow()]
            let files = Files.getLruListFiles(directory)

            list.clear()

            for (i in 0..files.size) {
                let singleFile = files.get(i).getOrThrow()
                list.append(singleFile)
            }
            totalSize = countTotalSize(list)
            totalCount = files.size
            for (i in 0..files.size) {
                let file: String = files[i]

                let accept: Bool = accept(file, totalSize, totalCount)

                if (!accept) {
                    let fileSize = FileFs.stat(file).size
                    FileFs.unlink(file)
                    totalCount--
                    totalSize -= fileSize
                }
            }
        }
    }
}
