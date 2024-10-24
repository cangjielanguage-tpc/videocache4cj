
## videocache4cj

### 介绍
videoCache4cj是一个支持边播放边缓存的库，只需要将音视频的url传递给videoCache4cj处理之后再设置给播放器，videoCache4cj就可以一边下载音视频数据并保存在本地，一遍读取本地缓存返回给播放器，使用者无需进行其他操作。

- 🚀 1.自定义设置缓存文件夹位置
- 🚀 2.设置最大缓存数据清理策略
- 🚀 3.添加请求头
- 🚀 4.使用自定义的缓存文件命名规则
- 🚀 5.注册/取消注册缓存进度监听器
- 🚀 6.设置自定义的缓存文件清理规则

### 1 videocache4cj 视频缓存库

#### 1.1 HttpProxyCacheServer 代理缓存服务类

```cangjie
public class HttpProxyCacheServer {
    
    /**
     * 获取服务端代理url
     * 
     * @参数 url - String数据类型，原视频的url
     * @参数 allowCachedFileUri - Bool数据类型，是否允许缓存文件 true 允许 false 不允许
     * @返回值 Future<String> 服务端代理url地址
     */
    public func getProxyUrl(url: String, allowCachedFileUri: Bool): Future<String>
    
    
    /**
     * 关闭代理服务器
     * 
     */
    public func shutdown(): Unit
    
    
    /**
     * 注册缓存监听
     *
     * @参数 cacheListener - CacheListener数据类型，缓存监听
     * @参数 url - String数据类型，下载的视频url
     */
    public func registerCacheListener(cacheListener: CacheListener, url: String): Unit 

    
    /**
     * 取消注册缓存监听
     *
     * @参数 cacheListener - CacheListener数据类型，缓存监听
     * @参数 url - String数据类型，下载的视频url
     */
    public func unregisterCacheListener(cacheListener: CacheListener, url: String): Unit

}
```

#### 1.2 HttpProxyCacheServerBuilder 代理缓存服务构建类

```cangjie
public class HttpProxyCacheServerBuilder {
    
    /**
     * 生成代理缓存服务类对象
     * 
     * @返回值 HttpProxyCacheServer 代理缓存服务类对象
     */
    public func build(): HttpProxyCacheServer 
    
    
    /**
     * 设置缓存目录
     * 
     * @参数 file - String缓存文件的目录
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func cacheDirectory(file: String): HttpProxyCacheServerBuilder
    
    
    /**
     * 设置文件名生成规则
     * 
     * @参数 fileNameGenerator - FileNameGenerator文件名生成规则类
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func setFileNameGenerator(fileNameGenerator: FileNameGenerator): HttpProxyCacheServerBuilder


    /**
     * 设置最大缓存大小
     * 
     * @参数 maxSize - Int64最大缓存大小 单位字节
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func maxCacheSize(maxSize: Int64): HttpProxyCacheServerBuilder

    
    /**
     * 设置最大缓存数量大小
     * 
     * @参数 count - 缓存文件的数量
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func maxCacheFilesCount(count: Int64): HttpProxyCacheServerBuilder


    /**
     * 设置自定义缓存清理策略
     * 
     * @参数 diskUsage - DiskUsage 自定义缓存策略
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func setDiskUsage(diskUsage: DiskUsage): HttpProxyCacheServerBuilder
    
    
     /**
     * 设置自定义请求头
     * 
     * @参数 headerInjector - HeaderInjector 自定义请求头
     * @返回值 HttpProxyCacheServerBuilder 代理缓存服务类构建对象
     */
    public func setHeaderInjector(headerInjector: HeaderInjector): HttpProxyCacheServerBuilder

}
```
