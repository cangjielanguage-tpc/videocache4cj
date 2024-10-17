/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class SourceInfo {
    public var url: String = ""
    public var length: Int64 = 0
    public var mime: String = ""

    init(url: String, length: Int64, mime: String) {
        this.url = url
        this.length = length
        this.mime = mime
    }

    public func toString(): String {
        return "SourceInfo{ url=${this.url}  length=${this.length} mime=${this.mime} }"
    }
}
