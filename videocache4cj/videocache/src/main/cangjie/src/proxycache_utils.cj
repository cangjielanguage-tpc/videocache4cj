/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class ProxyCacheUtils {
    static let DEFAULT_BUFFER_SIZE: Int64 = 8 * 1024
    static let MAX_ARRAY_PREVIEW: Int64 = 16

    public static func computeMD5(str: String): String {
        try {
            var md5Instance = MD5()
            var md: Array<Byte> = digest(md5Instance, str)
            var result: String = toHexString(md)
            return result
        } catch (e: Exception) {
            throw IllegalStateException("computeMD5 cause error")
        }
    }

    static func getSupposablyMime(url: String): String {
        let extension = ProxyCacheUtils.getFileExtensionFromUrl(url)
        // TODO MimeUtils.getMimeTypeFromExtension(extension)属于自行实现的方法 需要审视是否存在问题
        if (extension.size < 1) {
            return ""
        } else {
            return MimeUtils.getMimeTypeFromExtension(extension)
        }
    }

    public static func getFileExtensionFromUrl(url: String): String {
        var tempUrl = url
        if (url.size >= 1) {
            let fragment = url.lastIndexOf("#")
            if (fragment.isSome()) {
                tempUrl = url[0..fragment.getOrThrow()]
            }
            let query = url.lastIndexOf("?")
            if (query.isSome()) {
                tempUrl = url[0..query.getOrThrow()]
            }
            let fileNamePos = tempUrl.lastIndexOf("/") ?? -1
            var fileName: String = ""
            if (fileNamePos >= 0) {
                fileName = tempUrl[fileNamePos + 1..]
            } else {
                fileName = tempUrl
            }
            if (fileName.size >= 1) {
                let regExp = Regex("[a-zA-Z_0-9\\.\\-\\(\\)\\%]+")
                let isMatch = regExp.matches(fileName)
                if (isMatch.isSome()) {
                    let dotPos = fileName.lastIndexOf(".") ?? -1
                    if (dotPos >= 0) {
                        return fileName[dotPos + 1..]
                    }
                }
            }
        }
        return ""
    }

}
