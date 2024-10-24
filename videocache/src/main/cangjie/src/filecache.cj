/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class FileCache <: Cache {
    private var TEMP_POSTFIX: String = ".download"
    private var diskUsage: ?DiskUsage = None
    private var dataFile: RandomAccessFile
    public var tempFilePath: String = ""
    public var trueFilePath: String = ""
    public var parentPath: String = ""
    public var fileLength: Int64 = 0
    private var isRenamedEnd: Bool = true

    init(filePath: String, diskUsage: DiskUsage) {
        try {
            if (filePath.size < 1) {
                throw NoneValueException("filePath is null")
            }
            this.trueFilePath = filePath
            this.diskUsage = diskUsage
            let last = filePath.lastIndexOf("/")
            let lastPoint = filePath.lastIndexOf(".")
            let directory: String = filePath[0..last.getOrThrow()]
            this.parentPath = directory
            let fileName = filePath[last.getOrThrow() + 1..]
            if (!FileFs.access(directory)) {
                FileFs.mkdir(directory)
            }
            let completed: Bool = FileFs.access(filePath)
            if (completed) {
                this.tempFilePath = filePath
            } else {
                this.tempFilePath = directory + '/' + fileName + this.TEMP_POSTFIX
            }
            if (!completed) {
                this.dataFile = FileFs.createRandomAccessFile(this.tempFilePath, mode: (CREATE.mode | READ_WRITE.mode))
                FileFs.close(this.dataFile.fd)
            }
            this.dataFile = FileFs.createRandomAccessFile(this.tempFilePath, mode: (APPEND.mode | READ_WRITE.mode))
        } catch (e: Exception) {
            throw ProxyCacheException("Error using file " + this.tempFilePath + " as disc cache" + e.message)
        }
    }

    public func isCompleted(): Bool {
        let result = !this.isTempFile(this.tempFilePath)
        return result
    }

    public func complete() {
        try {
            if (this.isCompleted()) {
                return
            }
            this.isRenamedEnd = false
            FileFs.fsync(this.dataFile.fd)
            FileFs.close(this.dataFile.fd)
            FileFs.rename(this.tempFilePath, this.trueFilePath)
            this.tempFilePath = this.trueFilePath
            try {
                this.dataFile = FileFs.createRandomAccessFile(this.trueFilePath, mode: (CREATE.mode | READ_ONLY.mode))
            } catch (e: Exception) {
                throw ProxyCacheException("Error opening " + this.trueFilePath + " as disc cache,reason is : " + e.
                    message)
            }
        } catch (e: Exception) {
            throw ProxyCacheException(
                "Error renaming file " + this.tempFilePath + " to " + this.trueFilePath + " for completion! reason is : " +
                e.message)
        }
        this.isRenamedEnd = true
        let event: InnerEvent = InnerEvent(VideoCacheConstant.RENAME_FINISH_ID, priority: EventPriority.IMMEDIATE)
        Emitter.emit(event)
    }

    private func getFile(): RandomAccessFile {
        return this.dataFile
    }

    private func isTempFile(filePath: String): Bool {
        return filePath.endsWith(this.TEMP_POSTFIX)
    }

    public override func close(): Unit {
        try {
            if (!this.isRenamedEnd) {
                let event: InnerEvent = InnerEvent(VideoCacheConstant.RENAME_FINISH_ID)
                Emitter.on(event, EventCallback("RENAME_FINISH_ID", {data: EventData =>}))
            }
            Emitter.off(VideoCacheConstant.RENAME_FINISH_ID)
            FileFs.fsync(this.dataFile.fd)
            FileFs.close(this.dataFile.fd)
            return
        } catch (e: Exception) {
            throw ProxyCacheException("Error closing file " + this.tempFilePath + ',reason is : ' + e.message)
        }
    }

    public override func append(fileData: ByteArrayStream, length: Int64) {
        try {
            if (this.isCompleted()) {
                throw ProxyCacheException("Error append cache: cache file " + this.tempFilePath + " is completed!")
            }

            this.dataFile.write(fileData.bytes())
            FileFs.fsync(this.dataFile.fd)
        } catch (e: Exception) {
            let format = "Error writing ${length} bytes to ${this.tempFilePath}from buffer with size ${fileData.length},reason is : ${e.message}"
            throw ProxyCacheException(format)
        }
    }

    public override func read(buffer: Array<UInt8>, offset: Int64, length: Int64): Int64 {
        try {
            if (!this.isRenamedEnd) {
                return -1
            }
            if (offset < 0 || length < 0) {
                return -1
            }
            if (this.fileLength > 0 && offset >= this.fileLength) {
                this.diskUsage?.touch(this.tempFilePath)
                return -1
            }
            if (offset >= this.available()) {
                return -1
            }
            var tempLength: Int64 = 0
            if (offset + length >= this.fileLength && this.fileLength > 0) {
                tempLength = this.fileLength - offset
            } else if (offset + length >= this.available() && this.available() > 0) {
                tempLength = this.available() - offset
            } else {
                tempLength = length
            }
            let readLength = FileFs.read(this.dataFile.fd, buffer,
                options: ReadOptions(length: UIntNative(tempLength), offset: offset))
            return readLength
        } catch (e: Exception) {
            let format = "Error reading ${length} bytes with offset ${offset} from file[${this.available()} bytes] to buffer[${buffer.size} bytes], readon is : ${e.message}"
            throw ProxyCacheException(format)
        }
    }

    public func available(): Int64 {
        try {
            let size = FileFs.stat(this.tempFilePath).size
            return size
        } catch (e: Exception) {
            throw ProxyCacheException("Error reading length of file " + this.tempFilePath + ",reason is :    " + e.
                message)
        }
    }

    public func setFileLength(length: Int64) {
        if (length > 0) {
            this.fileLength = length
        }
    }

    public func totalLength(): Int64 {
        return this.fileLength
    }
}
