/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class EmptyHeadersInjector <: HeaderInjector {
    public func addHeaders(url: String): HashMap<String, String> {
        return HashMap<String, String>()
    }
}
