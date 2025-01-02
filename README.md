<div align="center">
<h1>videocache4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.53.15-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

videoCache4cj是一个支持边播放边缓存的库，只需要将音视频的url传递给videoCache4cj处理之后再设置给播放器，videoCache4cj就可以一边下载音视频数据并保存在本地，一遍读取本地缓存返回给播放器，使用者无需进行其他操作。

### 特性

- 🚀 1.自定义设置缓存文件夹位置
-
- 🚀 2.设置最大缓存数据清理策略
-
- 🚀 3.添加请求头
- 
- 🚀 4.使用自定义的缓存文件命名规则
- 
- 🚀 5.注册/取消注册缓存进度监听器
- 
- 🚀 6.设置自定义的缓存文件清理规则

### 源码目录

```shell
├── README.md                                 #整体介绍
├── doc                                       #文档目录
│   └── feature_api.md                        #API接口文档
├── videocache                                #源码目录 
├── entry                                     #示例目录
└── hvigor                                    #构建工具目录
```


### 接口说明

主要类和函数接口说明详见 [API](./doc/feature_api.md)

## 使用说明

### 编译构建

描述具体的编译过程：

```shell

    1.先通过命令把代码下载下来,
      git clone -b 具体分支名  https://gitcode.com/Cangjie-TPC/videocache4cj.git
          
    2.选择videocache模块,点击Build菜单,然后点击 Make Module 'videocache' 等待编译完成,项目则编译成功
    
```

### 功能示例

#### 1. 把videocache作为三方库依赖引入
```cj
用户如何在自己项目里引入videocache，具体步骤如下：
1. 在自己项目的根目录下,建一个thirdparty目录,然后通过git命令,把自己需要的ijk分支拉下来,比如
   git clone -b 分支名  https://gitcode.com/Cangjie-TPC/videocache4cj.git
2. 把 thirdparty文件下的videocache项目用deveco编译通过，方法如上面的编译构建
3. 在自己项目的根目录的build-profile.json5文件里的modules节点下添加
    {
      "name":"videocache",
      "srcPath": "./thirdparty/videocache4cj/videocache"
    }
   把videocache库的依赖变为modeule依赖形式.然后同步项目
4. 在自己项目的enrty里的oh-package.json5里的dependencies里加上     "videocache": "file:../thirdparty/videocache4cj/videocache",,然后同步项目
   "dependencies": {
      "videocache": "file:../thirdparty/videocache4cj/videocache",
      "libark_interop_loader.so": "file:./src/main/cangjie/loader"
  }
   项目即依赖成功
```

#### 2. 使用videocache生成代理url地址

示例代码如下：

```cangjie

/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry

public class GlobalProxyServer {
    private let CONTEXT_STR: String = "getContext"
    private let SERVER_STR: String = "getServer"
    private static var instance: ?GlobalProxyServer = None
    private var _objects: HashMap<String, Object> = HashMap<String, Object>()

    private init() {
    }

    public static func getInstance(): GlobalProxyServer {
        if (GlobalProxyServer.instance.isNone()) {
            GlobalProxyServer.instance = GlobalProxyServer()
        }
        return GlobalProxyServer.instance.getOrThrow()
    }

    func getContext(): ?AbilityContext {
        return this._objects.get(this.CONTEXT_STR).getOrThrow() as AbilityContext
    }

    func setContext(context: AbilityContext) {
        this._objects.put(this.CONTEXT_STR, context)
    }

    func getServer(): HttpProxyCacheServer {
        return (this._objects.get(this.SERVER_STR).getOrThrow() as HttpProxyCacheServer).getOrThrow()
    }

    func setServer(server: HttpProxyCacheServer) {
        try {
            let currentServer: HttpProxyCacheServer = this.getServer()
            currentServer.shutdown()
        } catch (e: Exception) {
        }
        this._objects.put(this.SERVER_STR, server)
    }
}



/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package ohos_app_cangjie_entry

import ohos.state_macro_manage.*
import std.time.Duration

@Entry
@Component
class MyView {
    @State
    var message: String = "Hello Cangjie"

    var proxyUrl:String = ""

    func build() {
        Row {
            Column {
                Button(message).onClick {
                            var originUrl = "https://vodpub1.v.news.cn/original/20230915/e6520e0158e44a7383bd137bd42f4451.mp4"
                            var server: HttpProxyCacheServer = HttpProxyCacheServerBuilder(globalAbilityContext.getOrThrow())
                            .cacheDirectory("自定义缓存目录")  //可选
                            .setFileNameGenerator("自定义文件命名规则类") //可选
                            .setHeaderInjector("自定义请求头类")  //可选
                            //.maxCacheSize(1024*1024*1024) //最大文件缓存 配合的是TotalCountLruDiskUsage //可选
                            //.maxCacheFilesCount(10) //最大缓存数量 配合的是TotalSizeLruDiskUsage //可选
                            .setDiskUsage("自定义缓存清理策略") //不设置默认走LrudiskUsage //可选
                            .build()
                            GlobalProxyServer.getInstance().setServer(server)
                            let tempUrl =  GlobalProxyServer.getInstance().getServer().getProxyUrl(originUrl,true)
                            if(tempUrl.get().size>0){
                                proxyUrl = tempUrl.get()
                            }else{
                                proxyUrl = originUrl
                            }
                            //this.avPlayer.url = proxyUrl; 把代理url地址赋值给播放器
                            Hilog.error(0x0000,"proxyUrl","${proxyUrl}")
                }.fontSize(40).height(80)
            }.width(100.percent)
        }.height(100.percent)
    }
}

```

执行结果如下：

```shell
  http://127.0.0.1:27180/https://vodpub1.v.news.cn/original/20230915/e6520e0158e44a7383bd137bd42f4451.mp4
```


## 约束与限制

IDE : DevEco Studio 5.0.1 Release (5.0.5.306)

Plugins (SDK) : DevEco Studio-Cangjie Plugin Beta1(5.0.5.300)
                

## 开源协议

本项目基于 [Apache License](./LICENSE) ，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。