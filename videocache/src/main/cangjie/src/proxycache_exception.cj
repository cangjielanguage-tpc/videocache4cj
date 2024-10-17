/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public open class ProxyCacheException <: Exception {
    init(msg: String) {
        super(msg + HttpProxyCacheServer.getLibraryVersion())
    }

    init(msg: String, cause: Exception) {
        super(msg + HttpProxyCacheServer.getLibraryVersion() + ",reason is :" + cause.message)
    }

    init(msg: Exception) {
        super("No explanation error" + HttpProxyCacheServer.getLibraryVersion())
    }

    init(msg: Exception, cause: Exception) {
        super("No explanation error" + HttpProxyCacheServer.getLibraryVersion() + ",reason is :" + cause.message)
    }
}
