/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package videocache

public class InterruptedProxyCacheException <: ProxyCacheException {
    init(args: String) {
        super(args)
    }

    init(args: Exception) {
        super(args.message)
    }

    init(args: String, args1: Exception) {
        super(args, args1)
    }
}
