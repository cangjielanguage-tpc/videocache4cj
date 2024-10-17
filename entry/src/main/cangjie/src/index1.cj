/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package ohos_app_cangjie_entry

import ohos.state_macro_manage.*

@Entry
@Component
class MyCase1 {
    @State
    var message: String = "Hello Cangjie"
    var proxyUrl: String = ""
    func build() {
        Row {
            Column {
                Button(message).onClick {
                    //var originUrl = "https://vodpub1.v.news.cn/original/20230915/e6520e0158e44a7383bd137bd42f4451.mp4"
                    var originUrl = "https://www.w3schools.com/html/movie.mp4"
                    var server: HttpProxyCacheServer = HttpProxyCacheServerBuilder(globalAbilityContext.getOrThrow()).
                        build()
                    GlobalProxyServer.getInstance().setServer(server)
                    let tempUrl = GlobalProxyServer.getInstance().getServer().getProxyUrl(originUrl, true)
                    if (tempUrl.get().size > 0) {
                        proxyUrl = tempUrl.get()
                    } else {
                        proxyUrl = originUrl
                    }
                    Hilog.error(0x0000, "testhhsproxyUrl", "${proxyUrl}")
                    //this.avPlayer!.url = proxyUrl
                }.fontSize(40).height(80)
            }.width(100.percent)
        }.height(100.percent)
    }
}
