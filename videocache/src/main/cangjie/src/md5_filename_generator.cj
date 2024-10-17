/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class Md5FileNameGenerator <: FileNameGenerator {
    private var MAX_EXTENSION_LENGTH: Int64 = 4

    public override func generate(url: String): String {
        let extension = this.getExtension(url)
        let name = ProxyCacheUtils.computeMD5(url)
        if (extension.size < 1) {
            return name
        } else {
            return name + "." + extension
        }
    }

    private func getExtension(url: String): String {
        let dotIndex = url.lastIndexOf(".") ?? return ""
        let slashIndex = url.lastIndexOf("/") ?? return ""
        if (dotIndex <= slashIndex) {
            return ""
        }
        if (dotIndex + 2 + this.MAX_EXTENSION_LENGTH <= url.size) {
            return ""
        }
        return url[dotIndex + 1..]
    }
}
