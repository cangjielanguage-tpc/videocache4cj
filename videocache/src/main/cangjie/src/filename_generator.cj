/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

public interface FileNameGenerator {
    func generate(url: String): String
}
