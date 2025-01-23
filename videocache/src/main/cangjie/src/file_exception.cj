/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

/**
 * FileException
 */
public class FileException <: Exception {
    /**
     * init
     *
     * @param messages - String the message
     */
    private var mMessage = ""

    public init(messages: String) {
        super(messages)
        this.mMessage = messages
    }

    public func toString():String{
        return "FileException: "+ mMessage
    }
}
