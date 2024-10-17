/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public interface HeaderInjector {
    func addHeaders(url: String): HashMap<String, String>
}
