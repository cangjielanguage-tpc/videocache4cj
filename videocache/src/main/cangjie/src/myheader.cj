/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class MyHeader {
    public var range: String = ''
    public var name: String = ''
    public var connection: String = ''
    public var contentType: String = ''

    init(contentType: String) {
        this.contentType = contentType
    }
}
