/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ijkplayer4cj

public class LogUtils {
    private var mLogOpen: Bool = false
    private var mTag: String = "ijkplayer:cj"
    private static var INSTANCE: ?LogUtils = None
    private init() {}

    public static func getInstance(): LogUtils {
        return if (let Some(i) <- LogUtils.INSTANCE) {
            i
        } else {
            let i = LogUtils()
            LogUtils.INSTANCE = i
            i
        }
    }

    public func setLogSwitch(logOpen: Bool) {
        this.mLogOpen = logOpen
    }

    public func LOGI(info: String) {
        if (mLogOpen) {
            AppLog.info(info)
        }
    }
}
