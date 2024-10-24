/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class Files {
    static func makeDir(directory: String): Unit {
        if (directory.size < 1) {
            throw IOException("directory can not be null!")
        }
        if (FileFs.access(directory)) {
            if (!FileFs.stat(directory).isDirectory()) {
                throw IOException("File " + directory + " is not directory!")
            }
        } else {
            try {
                FileFs.mkdir(directory, true)
            } catch (e: Exception) {
                throw IOException("Directory ${directory} can't be created,reason is :${e.message}")
            }
        }
    }

    static func getLruListFiles(directory: String): ArrayList<String> {
        let result = ArrayList<String>()
        try {
            var option = ListFileOptions(recursion: true, listNum: 0, filter: Filter())
            let files = FileFs.listFile(directory, options: option)
            if (files.size > 0) {
                for (i in 0..files.size) {
                    result.append(directory + files[i])
                }
                let len = result.size
                for (i in 0..len - 1) {
                    for (j in 0..len - 1 - i) {
                        let before = FileFs.stat(result[j]).ctime
                        let after = FileFs.stat(result[j + 1]).ctime
                        // 相邻元素两两对比，元素交换，大的元素交换到后面
                        if (before > after) { //	< 为升序排列，降序请换 >
                            let temp: String = result[j]
                            result[j] = result[j + 1]
                            result[j + 1] = temp
                        }
                    }
                }
            }
        } catch (e: Exception) {
        }
        return result
    }

    static func setLastModifiedNow(file: String): Unit {
        if (FileFs.access(file)) {
            try {
                //TODO
                FileFs.utimes(file, Float64(DateTime.now().toUnixTimeStamp().toNanoseconds()))
            } catch (e: Exception) {
                throw IOException("Last modified date is not set for file ${file},reason is ${e.message}")
            }
        } else {
            AppLog.error("file ${file} IS not exist")
        }
    }

    static func modify(file: String): Unit {
        let size = FileFs.stat(file).size
        if (size == 0) {
            Files.recreateZeroSizeFile(file)
            return
        }
    }

    //TODO
    private static func recreateZeroSizeFile(file: String): Unit {
        try {
            if (FileFs.access(file)) {
                FileFs.unlink(file)
            } else {
                let fd = FileFs.open(file, mode: (READ_WRITE.mode | CREATE.mode)).fd
                FileFs.close(fd)
            }
        } catch (e: Exception) {
            throw IOException("Error recreate zero-size file--- " + file)
        }
    }
}
