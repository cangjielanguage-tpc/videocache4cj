/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

public interface HeaderInjector {
    func addHeaders(url: String): HashMap<String, String>
}
