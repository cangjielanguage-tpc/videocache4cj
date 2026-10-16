/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package videocache

public open class ProxyCacheException <: Exception {
    init(msg: String) {
        super(msg + HttpProxyCacheServer.getLibraryVersion())
    }

    init(msg: String, cause: Exception) {
        super(msg + HttpProxyCacheServer.getLibraryVersion() + ",reason is :" + cause.message)
    }

    init(_: Exception) {
        super("No explanation error" + HttpProxyCacheServer.getLibraryVersion())
    }

    init(_: Exception, cause: Exception) {
        super("No explanation error" + HttpProxyCacheServer.getLibraryVersion() + ",reason is :" + cause.message)
    }
}
