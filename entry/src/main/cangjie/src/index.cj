/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_entry
import ohos.router.*
import ohos.state_macro_manage.*

@Entry
@Component
class MyView {
      let scroller = Scroller()
        func build() {
            Row {
                Scroll(this.scroller) {
                    Column {
                        Button("L0网络视频1").onClick {Router.push(url: "L0_Network")}
                        Button("L0网络视频").onClick {Router.push(url: "L0_Network1")}
                        Button("L1局域网视频").onClick {Router.push(url: "L1_Localareanetwork")}
                        Button("L1本地视频 ").onClick {Router.push(url: "L1_Locality")}
                        Button("L1网络视频1").onClick {Router.push(url: "L1_Network")}
                        Button("L1网络视频2").onClick {Router.push(url: "L1_Network2")}
                        Button("L1网络视频3").onClick {Router.push(url: "L1_Network3")}

                        Button("L1设置缓存目录").onClick {Router.push(url: "L1_Network_Directory")}
                        Button("L1设置缓存目录1").onClick {Router.push(url: "L1_Network_Directory1")}
                        Button("L1设置缓存目录2").onClick {Router.push(url: "L1_Network_Directory2")}

                        Button("L1设置缓存数量").onClick {Router.push(url: "L1_Network_MaxCacheFilesCount")}
                        Button("L1设置缓存数量1").onClick {Router.push(url: "L1_Network_MaxCacheFilesCount1")}
                        Button("L1设置缓存数量2").onClick {Router.push(url: "L1_Network_MaxCacheFilesCount2")}

                        Button("L1设置缓存大小").onClick {Router.push(url: "L1_Network_MaxCacheSize")}
                        Button("L1设置缓存大小1").onClick {Router.push(url: "L1_Network_MaxCacheSize1")}
                        Button("L1设置缓存大小2").onClick {Router.push(url: "L1_Network_MaxCacheSize2")}

                        Button("L1设置监听").onClick {Router.push(url: "L1_Network_RegisterCacheListener")}
                        Button("L1设置监听1").onClick {Router.push(url: "L1_Network_RegisterCacheListener1")}

                        Button("L1设置清理策略").onClick {Router.push(url: "L1_Network_SetDiskUsage")}
                        Button("L1设置清理策略1").onClick {Router.push(url: "L1_Network_SetDiskUsage1")}

                        Button("L1设置缓存名称").onClick {Router.push(url: "L1_Network_SetFileNameGenerator")}
                        Button("L1设置缓存名称1").onClick {Router.push(url: "L1_Network_SetFileNameGenerator1")}
                        Button("L1设置缓存名称2").onClick {Router.push(url: "L1_Network_SetFileNameGenerator2")}
                        Button("L1设置缓存名称3").onClick {Router.push(url: "L1_Network_SetFileNameGenerator3")}

                        Button("L1设置请求头").onClick {Router.push(url: "L1_Network_SetHeaderInjector")}
                        Button("L1设置请求头1").onClick {Router.push(url: "L1_Network_SetHeaderInjector1")}
                        Button("L1设置请求头2").onClick {Router.push(url: "L1_Network_SetHeaderInjector2")}
                        Button("L1设置请求头3").onClick {Router.push(url: "L1_Network_SetHeaderInjector3")}
                        Button("L1设置请求头4").onClick {Router.push(url: "L1_Network_SetHeaderInjector4")}

                        Button("L1设置取消监听").onClick {Router.push(url: "L1_Network_unregisterCacheListener")}
                        Button("L1设置取消监听1").onClick {Router.push(url: "L1_Network_unregisterCacheListener1")}

                        Button("网络视频设置").onClick {Router.push(url: "L1_Network_VideoCache")}
                        Button("网络视频设置1").onClick {Router.push(url: "L1_Network_VideoCache1")}
                        Button("网络视频设置2").onClick {Router.push(url: "L1_Network_VideoCache2")}
                        Button("网络视频设置3").onClick {Router.push(url: "L1_Network_VideoCache3")}
                        Button("网络视频设置4").onClick {Router.push(url: "L1_Network_VideoCache4")}
                        Button("网络视频设置5").onClick {Router.push(url: "L1_Network_VideoCache5")}
                        Button("网络视频设置6").onClick {Router.push(url: "L1_Network_VideoCache6")}
                        Button("网络视频设置7").onClick {Router.push(url: "L1_Network_VideoCache7")}
                        Button("网络视频设置8").onClick {Router.push(url: "L1_Network_VideoCache8")}

                        Button("局域网视频设置").onClick {Router.push(url: "L1_Network_VideoCache_File")}
                        Button("局域网视频设置1").onClick {Router.push(url: "L1_Network_VideoCache_File1")}
                        Button("局域网视频设置2").onClick {Router.push(url: "L1_Network_VideoCache_File2")}
                        Button("局域网视频设置3").onClick {Router.push(url: "L1_Network_VideoCache_File3")}
                        Button("局域网视频设置4").onClick {Router.push(url: "L1_Network_VideoCache_File4")}
                        Button("局域网视频设置5").onClick {Router.push(url: "L1_Network_VideoCache_File5")}
                        Button("局域网视频设置6").onClick {Router.push(url: "L1_Network_VideoCache_File6")}
                        Button("局域网视频设置7").onClick {Router.push(url: "L1_Network_VideoCache_File7")}
                        Button("局域网视频设置8").onClick {Router.push(url: "L1_Network_VideoCache_File8")}

                         Button("视频设置").onClick {Router.push(url: "L1_VideoCache")}
                        Button("视频设置1").onClick {Router.push(url: "L1_VideoCache1")}
                        Button("视频设置2").onClick {Router.push(url: "L1_VideoCache2")}
                        Button("视频设置3").onClick {Router.push(url: "L1_VideoCache3")}
                        Button("视频设置4").onClick {Router.push(url: "L1_VideoCache4")}
                        Button("视频设置5").onClick {Router.push(url: "L1_VideoCache5")}
                        Button("视频设置6").onClick {Router.push(url: "L1_VideoCache6")}
                        Button("视频设置7").onClick {Router.push(url: "L1_VideoCache7")}
                        Button("视频设置8").onClick {Router.push(url: "L1_VideoCache8")}

                        Button("L2设置缓存目录").onClick {Router.push(url: "L2_Network_Directory")}
                        Button("L2设置缓存目录1").onClick {Router.push(url: "L2_Network_Directory1")}
                        Button("L2设置缓存目录2").onClick {Router.push(url: "L2_Network_Directory2")}

                        Button("L2设置缓存数量").onClick {Router.push(url: "L2_Network_MaxCacheFilesCount")}
                        Button("L2设置缓存数量1").onClick {Router.push(url: "L2_Network_MaxCacheFilesCount1")}

                        Button("L2设置缓存大小").onClick {Router.push(url: "L2_Network_MaxCacheSize")}
                        Button("L2设置缓存大小1").onClick {Router.push(url: "L2_Network_MaxCacheSize1")}

                        Button("L2设置命名规则").onClick {Router.push(url: "L2_Network_SetFileNameGenerator")}
                        Button("L2设置命名规则1").onClick {Router.push(url: "L2_Network_SetFileNameGenerator1")}

                        Button("L2异常地址").onClick {Router.push(url: "L2_Videocache")}
                        Button("L2异常地址1").onClick {Router.push(url: "L2_Videocache1")}
                        Button("L2异常地址2").onClick {Router.push(url: "L2_Videocache2")}
                        Button("L2异常地址3").onClick {Router.push(url: "L2_Videocache3")}
                    }.width(100.percent)
                }
            }.height(100.percent)
    }
}
