/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

public class EmptyHeadersInjector <: HeaderInjector {
    public func addHeaders(_: String): HashMap<String, String> {
        return HashMap<String, String>()
    }
}
